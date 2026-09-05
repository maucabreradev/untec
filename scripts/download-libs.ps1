# Script para descargar dependencias JAR para el proyecto Eclipse Dynamic Web
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ProgressPreference = 'SilentlyContinue'

$destDir = Join-Path $PSScriptRoot "..\WebContent\WEB-INF\lib"
$testLibDir = Join-Path $PSScriptRoot "..\lib-test"

if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
}
if (-not (Test-Path $testLibDir)) {
    New-Item -ItemType Directory -Force -Path $testLibDir | Out-Null
}

$libraries = @(
    @{
        Name = "mysql-connector-j-8.3.0.jar"
        Dir  = $destDir
        Url  = "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar"
    },
    @{
        Name = "taglibs-standard-impl-1.2.5.jar"
        Dir  = $destDir
        Url  = "https://repo1.maven.org/maven2/org/apache/taglibs/taglibs-standard-impl/1.2.5/taglibs-standard-impl-1.2.5.jar"
    },
    @{
        Name = "taglibs-standard-spec-1.2.5.jar"
        Dir  = $destDir
        Url  = "https://repo1.maven.org/maven2/org/apache/taglibs/taglibs-standard-spec/1.2.5/taglibs-standard-spec-1.2.5.jar"
    },
    @{
        Name = "javax.servlet-api-4.0.1.jar"
        Dir  = $destDir
        Url  = "https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar"
    },
    @{
        Name = "junit-platform-console-standalone-1.10.2.jar"
        Dir  = $testLibDir
        Url  = "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.2/junit-platform-console-standalone-1.10.2.jar"
    }
)

foreach ($lib in $libraries) {
    $targetPath = Join-Path $lib.Dir $lib.Name
    if (-not (Test-Path $targetPath)) {
        Write-Host "Descargando $($lib.Name)..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $lib.Url -OutFile $targetPath
        Write-Host "OK: $($lib.Name)" -ForegroundColor Green
    } else {
        Write-Host "Ya existe: $($lib.Name)" -ForegroundColor Yellow
    }
}

Write-Host "Todas las librerías se encuentran listas (producción y testing)." -ForegroundColor Green
