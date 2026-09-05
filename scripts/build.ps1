# ==============================================================================
# SCRIPT DE COMPILACIÓN Y EMPAQUETADO WAR - BIBLIOTECA DIGITAL UNTEC
# Compatible con PowerShell 5.1+ y PowerShell 7+ en Windows
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  COMPILACIÓN Y GENERACIÓN DE .WAR: BIBLIOTECA UNTEC        " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$baseDir = Resolve-Path (Join-Path $PSScriptRoot "..")
$srcDir = Join-Path $baseDir "src"
$webContentDir = Join-Path $baseDir "WebContent"
$libDir = Join-Path $webContentDir "WEB-INF\lib"
$buildDir = Join-Path $baseDir "build"
$classesDir = Join-Path $buildDir "classes"
$stagingDir = Join-Path $buildDir "war_staging"
$distDir = Join-Path $baseDir "dist"
$warName = "biblioteca-untec.war"
$warPath = Join-Path $distDir $warName

# 1. Verificar herramientas JDK
try {
    $javacVersion = & javac -version 2>&1
    Write-Host "[1/6] Compilador Java detectado: $javacVersion" -ForegroundColor Green
} catch {
    Write-Error "No se encontró 'javac' en el PATH. Asegúrate de tener instalado Java JDK (JDK 8 o superior)."
    exit 1
}

# 2. Limpiar y preparar carpetas
Write-Host "[2/6] Preparando carpetas de trabajo temporales..." -ForegroundColor Yellow
if (Test-Path $buildDir) { Remove-Item -Recurse -Force $buildDir }
if (Test-Path $distDir) { Remove-Item -Recurse -Force $distDir }

New-Item -ItemType Directory -Force -Path $classesDir | Out-Null
New-Item -ItemType Directory -Force -Path $stagingDir | Out-Null
New-Item -ItemType Directory -Force -Path $distDir | Out-Null

# 3. Construir Classpath con las librerías JAR
Write-Host "[3/6] Resolviendo librerías en WebContent\WEB-INF\lib..." -ForegroundColor Yellow
$jarFiles = Get-ChildItem -Path $libDir -Filter "*.jar" | ForEach-Object { $_.FullName }
if ($jarFiles.Count -eq 0) {
    Write-Host "No se encontraron librerías JAR. Ejecutando scripts\download-libs.ps1..." -ForegroundColor Yellow
    & (Join-Path $PSScriptRoot "download-libs.ps1")
    $jarFiles = Get-ChildItem -Path $libDir -Filter "*.jar" | ForEach-Object { $_.FullName }
}

$classpath = $jarFiles -join ";"
Write-Host "      Librerías encontradas: $($jarFiles.Count)" -ForegroundColor Gray

# 4. Compilar clases Java
Write-Host "[4/6] Compilando código fuente Java (.java -> .class)..." -ForegroundColor Yellow
$javaSources = Get-ChildItem -Path $srcDir -Filter "*.java" -Recurse | ForEach-Object { $_.FullName }
Write-Host "      Archivos .java a compilar: $($javaSources.Count)" -ForegroundColor Gray

# Crear archivo de fuentes para javac sin BOM
$sourcesFile = Join-Path $buildDir "sources.txt"
[System.IO.File]::WriteAllLines($sourcesFile, $javaSources)

& javac -encoding UTF-8 -cp $classpath -d $classesDir "@$sourcesFile"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error durante la compilación con javac. Código de salida: $LASTEXITCODE"
    exit 1
}
Write-Host "      Compilación exitosa." -ForegroundColor Green

# 5. Copiar recursos (db.properties) al directorio classes
$propFile = Join-Path $srcDir "db.properties"
if (Test-Path $propFile) {
    Copy-Item $propFile -Destination $classesDir -Force
    Write-Host "      db.properties copiado a WEB-INF/classes." -ForegroundColor Gray
}

# 6. Ensamblar estructura del WAR y empaquetar
Write-Host "[5/6] Ensamblando contenido WebContent..." -ForegroundColor Yellow
Copy-Item -Path "$webContentDir\*" -Destination $stagingDir -Recurse -Force

# Asegurar que clases compiladas estén en WEB-INF/classes del WAR
$stagingClassesDir = Join-Path $stagingDir "WEB-INF\classes"
if (-not (Test-Path $stagingClassesDir)) {
    New-Item -ItemType Directory -Force -Path $stagingClassesDir | Out-Null
}
Copy-Item -Path "$classesDir\*" -Destination $stagingClassesDir -Recurse -Force

Write-Host "[6/6] Empaquetando archivo WAR: $warName..." -ForegroundColor Yellow
Push-Location $stagingDir
try {
    & jar -cf $warPath *
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al empaquetar con jar. Código de salida: $LASTEXITCODE"
        exit 1
    }
} finally {
    Pop-Location
}

$warSizeMb = (Get-Item $warPath).Length / 1MB
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  ¡ÉXITO! ARCHIVO WAR GENERADO SATISFACTORIAMENTE           " -ForegroundColor Green
Write-Host "  Ubicación: $warPath" -ForegroundColor White
Write-Host "  Tamaño: $([math]::Round($warSizeMb, 2)) MB" -ForegroundColor White
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Despliegue:" -ForegroundColor Cyan
Write-Host "  1. Copia '$warName' a la carpeta 'webapps/' de tu Apache Tomcat 9." -ForegroundColor Gray
Write-Host "  2. O usa Tomcat Web Application Manager: http://localhost:8080/manager/html" -ForegroundColor Gray
Write-Host "  3. Abre en tu navegador: http://localhost:8080/biblioteca-untec/" -ForegroundColor Gray
Write-Host "============================================================" -ForegroundColor Cyan
