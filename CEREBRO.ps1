# ==========================================
# CEREBRO DEPLOY v1.1
# ==========================================

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "====================================="
Write-Host "      CEREBRO DEPLOY INICIADO"
Write-Host "====================================="
Write-Host ""

# ==========================================
# COMPROBAR WINGET
# ==========================================

if (!(Get-Command winget -ErrorAction SilentlyContinue))
{
    Write-Host "ERROR: Winget no esta disponible."
    exit
}

# ==========================================
# INSTALACION DE APLICACIONES
# ==========================================

$Apps = @(
    "Google.Chrome",
    "Google.GoogleDrive",
    "Tailscale.Tailscale",
    "RustDesk.RustDesk",
    "VideoLAN.VLC",
    "7zip.7zip"
)

foreach ($App in $Apps)
{
    try
    {
        Write-Host ""
        Write-Host "Instalando $App..."

        winget install `
            --id $App `
            --exact `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements

        Write-Host "OK -> $App"
    }
    catch
    {
        Write-Host "ERROR -> $App"
    }
}

# ==========================================
# MODO OSCURO
# ==========================================

Write-Host "Aplicando modo oscuro..."

New-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -Name "AppsUseLightTheme" `
    -Value 0 `
    -PropertyType DWord `
    -Force | Out-Null

New-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -Name "SystemUsesLightTheme" `
    -Value 0 `
    -PropertyType DWord `
    -Force | Out-Null

# ==========================================
# EXPLORADOR
# ==========================================

Write-Host "Configurando explorador..."

# Mostrar extensiones

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "HideFileExt" `
    -Value 0

# Mostrar ocultos

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "Hidden" `
    -Value 1

# ==========================================
# BARRA DE TAREAS
# ==========================================

Write-Host "Configurando barra de tareas..."

# Mantener centrada

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "TaskbarAl" `
    -Value 1 `
    -ErrorAction SilentlyContinue

# Ocultar búsqueda

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
    -Name "SearchboxTaskbarMode" `
    -Value 0 `
    -Type DWord `
    -ErrorAction SilentlyContinue

# Ocultar widgets

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "TaskbarDa" `
    -Value 0 `
    -ErrorAction SilentlyContinue

# Ocultar vista de tareas

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "ShowTaskViewButton" `
    -Value 0 `
    -ErrorAction SilentlyContinue

# ==========================================
# COLOR DE ENFASIS VERDE
# ==========================================

Write-Host "Aplicando color de enfasis..."

New-Item `
    -Path "HKCU:\Software\Microsoft\Windows\DWM" `
    -Force | Out-Null

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\DWM" `
    -Name "ColorizationColor" `
    -Value 10806272 `
    -Type DWord `
    -ErrorAction SilentlyContinue

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\DWM" `
    -Name "ColorPrevalence" `
    -Value 1 `
    -Type DWord `
    -ErrorAction SilentlyContinue

# ==========================================
# CONFIGURACION DEL RATON
# ==========================================

Write-Host "Configurando raton..."

# Velocidad 13

Set-ItemProperty `
    -Path "HKCU:\Control Panel\Mouse" `
    -Name "MouseSensitivity" `
    -Value "13"

# Cursor Windows 11 personalizado

New-Item `
    -Path "HKCU:\Software\Microsoft\Accessibility" `
    -Force | Out-Null

# Tamaño 2

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Accessibility" `
    -Name "CursorSize" `
    -Value 2 `
    -Type DWord `
    -ErrorAction SilentlyContinue

# Color verde

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Accessibility" `
    -Name "CursorColor" `
    -Value 65280 `
    -Type DWord `
    -ErrorAction SilentlyContinue

# ==========================================
# ENERGIA
# ==========================================

Write-Host "Configurando energia..."

powercfg /hibernate off

powercfg /change standby-timeout-ac 0

powercfg /change monitor-timeout-ac 0

# ==========================================
# WALLPAPER
# ==========================================

Write-Host "Aplicando wallpaper..."

try
{
    $WallpaperFolder = "$env:PUBLIC\Pictures"

    if (!(Test-Path $WallpaperFolder))
    {
        New-Item `
            -ItemType Directory `
            -Path $WallpaperFolder `
            -Force | Out-Null
    }

    $WallpaperFile = "$WallpaperFolder\t3st-scr1pt.png"

    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/t3st-scr1pt/CEREBRO-DEPLOY/main/wallpapers/t3st-scr1pt.png" `
        -OutFile $WallpaperFile

    Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool SystemParametersInfo(
        int uAction,
        int uParam,
        string lpvParam,
        int fuWinIni);
}
"@

    [Wallpaper]::SystemParametersInfo(
        20,
        0,
        $WallpaperFile,
        3
    )

    Write-Host "Wallpaper aplicado correctamente."
}
catch
{
    Write-Host "ERROR aplicando wallpaper."
}

# ==========================================
# REINICIAR EXPLORADOR
# ==========================================

Write-Host "Reiniciando Explorer..."

Stop-Process `
    -Name explorer `
    -Force `
    -ErrorAction SilentlyContinue

Start-Sleep 2

Start-Process explorer.exe

# ==========================================
# FINALIZADO
# ==========================================

Write-Host ""
Write-Host "====================================="
Write-Host " CEREBRO DEPLOY FINALIZADO "
Write-Host "====================================="
Write-Host ""

Start-Sleep 5