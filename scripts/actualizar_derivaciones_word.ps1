$ErrorActionPreference = 'Stop'
$raizDerivaciones = Split-Path -Parent $PSScriptRoot
$rutaDerivaciones = Join-Path $raizDerivaciones 'Documentos\04-Administrativo-TG2\Avances\Derivaciones-Matematicas-TG2-2026-09-23.docx'
$carpetaTrabajoDerivaciones = Join-Path $raizDerivaciones '.tools\derivaciones\render'
$null = New-Item -ItemType Directory -Path $carpetaTrabajoDerivaciones -Force
$copiaDerivaciones = Join-Path $carpetaTrabajoDerivaciones 'derivaciones.docx'
Copy-Item -LiteralPath $rutaDerivaciones -Destination $copiaDerivaciones -Force
$wordDerivaciones = $null
$documentoDerivaciones = $null
try {
    # Se trabaja en una instancia oculta y una copia del documento generado.
    $wordDerivaciones = New-Object -ComObject Word.Application
    $wordDerivaciones.Visible = $false
    $wordDerivaciones.DisplayAlerts = 0
    $wordDerivaciones.AutomationSecurity = 3
    $wordDerivaciones.Options.UpdateLinksAtPrint = $false
    $wordDerivaciones.Options.PrintBackground = $false
    $wordDerivaciones.Options.BackgroundSave = $false
    $documentoDerivaciones = $wordDerivaciones.Documents.Open($copiaDerivaciones, $false, $false)
    foreach ($estiloIndiceDerivaciones in @(-20, -21)) {
        $estiloDerivaciones = $documentoDerivaciones.Styles.Item($estiloIndiceDerivaciones)
        $estiloDerivaciones.Font.Name = 'Times New Roman'
        $estiloDerivaciones.Font.Size = 10.5
        $estiloDerivaciones.ParagraphFormat.LineSpacingRule = 0
        $estiloDerivaciones.ParagraphFormat.SpaceBefore = 0
        $estiloDerivaciones.ParagraphFormat.SpaceAfter = 0
    }
    $documentoDerivaciones.Sections.Item(1).PageSetup.DifferentFirstPageHeaderFooter = $true
    $pieDerivaciones = $documentoDerivaciones.Sections.Item(1).Footers.Item(1)
    if ($pieDerivaciones.PageNumbers.Count -eq 0) { $null = $pieDerivaciones.PageNumbers.Add(1) }
    $pieDerivaciones.Range.Font.Name = 'Times New Roman'
    $pieDerivaciones.Range.Font.Size = 10
    $documentoDerivaciones.Repaginate()
    for ($indiceDerivaciones = 1; $indiceDerivaciones -le $documentoDerivaciones.TablesOfContents.Count; $indiceDerivaciones++) {
        $documentoDerivaciones.TablesOfContents.Item($indiceDerivaciones).Update()
    }
    $documentoDerivaciones.Repaginate()
    for ($indiceDerivaciones = 1; $indiceDerivaciones -le $documentoDerivaciones.TablesOfContents.Count; $indiceDerivaciones++) {
        $documentoDerivaciones.TablesOfContents.Item($indiceDerivaciones).UpdatePageNumbers()
    }
    $documentoDerivaciones.Save()
    Write-Output "Documento actualizado: $($documentoDerivaciones.ComputeStatistics(2)) paginas; $($documentoDerivaciones.Tables.Count) tablas."
} finally {
    if ($null -ne $documentoDerivaciones) {
        $documentoDerivaciones.Close(0)
        [void][System.Runtime.InteropServices.Marshal]::FinalReleaseComObject($documentoDerivaciones)
    }
    if ($null -ne $wordDerivaciones) {
        $wordDerivaciones.Quit()
        [void][System.Runtime.InteropServices.Marshal]::FinalReleaseComObject($wordDerivaciones)
    }
}
Copy-Item -LiteralPath $copiaDerivaciones -Destination $rutaDerivaciones -Force
