param([switch]$SoloInventario)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$projectRoot = Split-Path -Parent $PSScriptRoot
$manuscriptPath = Join-Path $projectRoot 'Documentos\01-Manuscrito\Tesis-NEXUS-completa.docx'
$renderDirectory = Join-Path $projectRoot '.tools\render-word'
$null = New-Item -ItemType Directory -Path $renderDirectory -Force
$wordApp = $null
$wordDocument = $null
try {
    $wordApp = New-Object -ComObject Word.Application
    $wordApp.Visible = $false
    $wordApp.DisplayAlerts = 0
    $wordApp.AutomationSecurity = 3
    $wordDocument = $wordApp.Documents.Open($manuscriptPath, $false, $true)
    $wordDocument.ActiveWindow.View.Type = 3
    $wordDocument.Repaginate()
    $pages = $wordDocument.ActiveWindow.Panes.Item(1).Pages
    $pageCount = $pages.Count
    $tableLayout = @()
    for ($tableIndex = 1; $tableIndex -le $wordDocument.Tables.Count; $tableIndex++) {
        $table = $wordDocument.Tables.Item($tableIndex)
        $startRange = $table.Range.Duplicate
        $startRange.Collapse(1)
        $endRange = $table.Rows.Item($table.Rows.Count).Cells.Item(1).Range.Duplicate
        $endRange.Collapse(1)
        $captionRange = $table.Range.Previous(4)
        $tableLayout += [pscustomobject]@{
            tabla = $tableIndex
            pagina_inicio = $startRange.Information(3)
            pagina_fin = $endRange.Information(3)
            pagina_rotulo = $captionRange.Information(3)
        }
    }
    $figureLayout = @()
    for ($figureIndex = 1; $figureIndex -le $wordDocument.InlineShapes.Count; $figureIndex++) {
        $figure = $wordDocument.InlineShapes.Item($figureIndex)
        if ($figure.Type -ne 3) { continue }
        $figureLayout += [pscustomobject]@{
            figura = $figureLayout.Count + 1
            pagina = $figure.Range.Information(3)
            pagina_rotulo = $figure.Range.Previous(4).Information(3)
            ancho_pt = $figure.Width
            alto_pt = $figure.Height
        }
    }
    $mathLayout = @()
    for ($mathIndex = 1; $mathIndex -le $wordDocument.OMaths.Count; $mathIndex++) {
        $equation = $wordDocument.OMaths.Item($mathIndex)
        if ($equation.Type -eq 0) {
            $mathStart = $equation.Range.Duplicate
            $mathStart.Collapse(1)
            $mathEnd = $equation.Range.Duplicate
            $mathEnd.Collapse(0)
            $mathLayout += [pscustomobject]@{
                ecuacion = $mathLayout.Count + 1
                pagina = $equation.Range.Information(3)
                y_inicio_pt = $mathStart.Information(6)
                y_fin_pt = $mathEnd.Information(6)
            }
        }
    }
    $layoutReport = [pscustomobject]@{
        paginas_word = $pageCount; tablas = $tableLayout
        figuras = $figureLayout; ecuaciones_bloque = $mathLayout
    }
    $evidenceDate = $env:NEXUS_TG2_FECHA_EVIDENCIA
    if ([string]::IsNullOrWhiteSpace($evidenceDate)) { $evidenceDate = Get-Date -Format 'yyyy-MM-dd' }
    $null = [datetime]::ParseExact($evidenceDate, 'yyyy-MM-dd', [cultureinfo]::InvariantCulture)
    $evidenceDirectory = Join-Path $projectRoot "Documentos\06-Evidencia-TG2\$evidenceDate"
    $null = New-Item -ItemType Directory -Path $evidenceDirectory -Force
    $layoutReport | Add-Member -NotePropertyName fecha -NotePropertyValue $evidenceDate
    $reportPath = Join-Path $evidenceDirectory 'paginacion-word.json'
    $layoutReport | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $reportPath -Encoding UTF8
    if ($SoloInventario) { Write-Output 'Inventario de maquetacion actualizado.'; return }
    Write-Output "Renderizando $pageCount paginas de Word."
    for ($pageIndex = 1; $pageIndex -le $pageCount; $pageIndex++) {
        # Word proporciona la imagen nativa de la página sin usar su exportador PDF.
        [byte[]]$pageBytes = $pages.Item($pageIndex).EnhMetaFileBits
        $memory = New-Object System.IO.MemoryStream(,$pageBytes)
        $metafile = [System.Drawing.Imaging.Metafile]::new($memory)
        $bitmap = [System.Drawing.Bitmap]::new(918,1188)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.Clear([System.Drawing.Color]::White)
        $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($metafile,0,0,918,1188)
        $bitmap.Save((Join-Path $renderDirectory ('word-{0:D3}.png' -f $pageIndex)),[System.Drawing.Imaging.ImageFormat]::Png)
        $graphics.Dispose()
        $bitmap.Dispose()
        $metafile.Dispose()
        $memory.Dispose()
    }
    Write-Output 'Imagenes de Word generadas.'
} finally {
    if ($null -ne $wordDocument) { $wordDocument.Close(0) }
    if ($null -ne $wordApp) { $wordApp.Quit() }
}
