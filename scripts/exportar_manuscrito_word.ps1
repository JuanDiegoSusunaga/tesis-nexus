$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$manuscriptPath = Join-Path $projectRoot 'Documentos\01-Manuscrito\Tesis-NEXUS-completa.docx'
$renderDirectory = Join-Path $projectRoot '.tools\render'
$null = New-Item -ItemType Directory -Path $renderDirectory -Force
$workingDocPath = Join-Path $renderDirectory 'manuscrito.docx'
Copy-Item -LiteralPath $manuscriptPath -Destination $workingDocPath -Force
$wordApp = $null
$wordDocument = $null

try {
    # Esta instancia permanece oculta y abre solo el documento generado.
    $wordApp = New-Object -ComObject Word.Application
    $wordApp.Visible = $false
    $wordApp.DisplayAlerts = 0
    $wordApp.AutomationSecurity = 3
    $wordApp.Options.UpdateFieldsAtPrint = $false
    $wordApp.Options.UpdateLinksAtPrint = $false
    $wordApp.Options.PrintBackground = $false
    $wordApp.Options.BackgroundSave = $false
    Write-Output 'Word iniciado; abriendo la edicion generada.'
    $wordDocument = $wordApp.Documents.Open($workingDocPath, $false, $false)
    Write-Output 'Documento abierto.'
    # Identificadores integrados de TOC 1 y TOC 2, independientes del idioma de Word.
    foreach ($tocStyleId in @(-20,-21)) {
        $tocStyle = $wordDocument.Styles.Item($tocStyleId)
        $tocStyle.Font.Name = 'Times New Roman'
        $tocStyle.Font.Size = 11
        $tocStyle.ParagraphFormat.LineSpacingRule = 0
        $tocStyle.ParagraphFormat.SpaceBefore = 0
        $tocStyle.ParagraphFormat.SpaceAfter = 2
    }
    $wordDocument.Sections.Item(1).PageSetup.DifferentFirstPageHeaderFooter = $true
    $footer = $wordDocument.Sections.Item(1).Footers.Item(1)
    if ($footer.PageNumbers.Count -eq 0) {
        $null = $footer.PageNumbers.Add(1)
    }
    $footer.Range.Font.Name = 'Times New Roman'
    $footer.Range.Font.Size = 10
    $wordDocument.Repaginate()
    Write-Output 'Paginacion inicial terminada.'
    $tocCount = $wordDocument.TablesOfContents.Count
    for ($tocIndex = 1; $tocIndex -le $tocCount; $tocIndex++) {
        $wordDocument.TablesOfContents.Item($tocIndex).Update()
    }
    Write-Output 'Indice actualizado.'
    $wordDocument.Repaginate()
    for ($tocIndex = 1; $tocIndex -le $tocCount; $tocIndex++) {
        $wordDocument.TablesOfContents.Item($tocIndex).UpdatePageNumbers()
    }
    $wordDocument.Save()
    $pages = $wordDocument.ComputeStatistics(2)
    Write-Output "Word actualizado: $pages paginas; $($wordDocument.Tables.Count) tablas."
} finally {
    if ($null -ne $wordDocument) {
        $wordDocument.Close(0)
        [void][System.Runtime.InteropServices.Marshal]::FinalReleaseComObject($wordDocument)
    }
    if ($null -ne $wordApp) {
        $wordApp.Quit()
        [void][System.Runtime.InteropServices.Marshal]::FinalReleaseComObject($wordApp)
    }
}

# Publica el documento después de cerrar la instancia de Word.
Copy-Item -LiteralPath $workingDocPath -Destination $manuscriptPath -Force
