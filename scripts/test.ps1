# Script de ejecucion de pruebas automatizadas con JUnit 5
$ErrorActionPreference = 'Stop'

Write-Host '============================================================' -ForegroundColor Cyan
Write-Host '  EJECUCION DE PRUEBAS AUTOMATIZADAS (JUNIT 5) - UNTEC       ' -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan

$baseDir = Resolve-Path (Join-Path $PSScriptRoot '..')
$srcDir = Join-Path $baseDir 'src'
$testDir = Join-Path $baseDir 'test'
$webLibDir = Join-Path $baseDir 'WebContent\WEB-INF\lib'
$testLibDir = Join-Path $baseDir 'lib-test'
$buildDir = Join-Path $baseDir 'build'
$classesDir = Join-Path $buildDir 'classes'
$testClassesDir = Join-Path $buildDir 'test-classes'
$junitJar = Join-Path $testLibDir 'junit-platform-console-standalone-1.10.2.jar'

# 1. Verificar JUnit 5 Runner
if (-not (Test-Path $junitJar)) {
    Write-Host '[1/4] Descargando dependencias de testing...' -ForegroundColor Yellow
    & (Join-Path $PSScriptRoot 'download-libs.ps1')
} else {
    Write-Host '[1/4] Dependencias de testing verificadas.' -ForegroundColor Green
}

# 2. Compilar codigo fuente principal (src/) si no existe
Write-Host '[2/4] Verificando clases de produccion...' -ForegroundColor Yellow
if (-not (Test-Path (Join-Path $classesDir 'cl\untec\biblioteca\model\Usuario.class'))) {
    Write-Host '      Compilando src/...' -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path $classesDir | Out-Null
    $prodJars = (Get-ChildItem -Path $webLibDir -Filter '*.jar' | ForEach-Object { $_.FullName }) -join ';'
    $srcFiles = Get-ChildItem -Path $srcDir -Filter '*.java' -Recurse | ForEach-Object { $_.FullName }
    $srcList = Join-Path $buildDir 'sources_main.txt'
    [System.IO.File]::WriteAllLines($srcList, $srcFiles)
    & javac -encoding UTF-8 -cp $prodJars -d $classesDir "@$srcList"
    
    $prop = Join-Path $srcDir 'db.properties'
    if (Test-Path $prop) { Copy-Item $prop -Destination $classesDir -Force }
}
Write-Host '      Clases de produccion listas.' -ForegroundColor Green

# 3. Compilar codigo de pruebas (test/)
Write-Host '[3/4] Compilando clases de prueba (test/*.java)...' -ForegroundColor Yellow
if (Test-Path $testClassesDir) { Remove-Item -Recurse -Force $testClassesDir }
New-Item -ItemType Directory -Force -Path $testClassesDir | Out-Null

$prodJars = (Get-ChildItem -Path $webLibDir -Filter '*.jar' | ForEach-Object { $_.FullName }) -join ';'
$testClasspath = "$classesDir;$junitJar;$prodJars"

$testFiles = Get-ChildItem -Path $testDir -Filter '*.java' -Recurse | ForEach-Object { $_.FullName }
Write-Host "      Archivos de prueba encontrados: $($testFiles.Count)" -ForegroundColor Gray

$testList = Join-Path $buildDir 'sources_test.txt'
[System.IO.File]::WriteAllLines($testList, $testFiles)

& javac -encoding UTF-8 -cp $testClasspath -d $testClassesDir "@$testList"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error compilando las clases de prueba. Codigo: $LASTEXITCODE"
    exit 1
}
Write-Host '      Compilacion de pruebas exitosa.' -ForegroundColor Green

# 4. Ejecutar JUnit 5 Console Runner
Write-Host '[4/4] Ejecutando suite de pruebas con JUnit Platform...' -ForegroundColor Yellow
Write-Host '------------------------------------------------------------' -ForegroundColor DarkGray

$runClasspath = "$classesDir;$testClassesDir;$prodJars"

& java -jar $junitJar execute --class-path $runClasspath --scan-class-path --fail-if-no-tests

$exitCode = $LASTEXITCODE

Write-Host '------------------------------------------------------------' -ForegroundColor DarkGray
if ($exitCode -eq 0) {
    Write-Host '============================================================' -ForegroundColor Green
    Write-Host '  TODOS LOS TESTS DE LA BIBLIOTECA UNTEC HAN PASADO (100%)  ' -ForegroundColor Green
    Write-Host '============================================================' -ForegroundColor Green
} else {
    Write-Host '============================================================' -ForegroundColor Red
    Write-Host '  ALGUNAS PRUEBAS FALLARON. REVISA EL REPORTE ANTERIOR.     ' -ForegroundColor Red
    Write-Host '============================================================' -ForegroundColor Red
    exit $exitCode
}
