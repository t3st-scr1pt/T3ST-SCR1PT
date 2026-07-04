# ==========================================
# CEREBRO DEPLOY v1.3
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
    Write-Host "ERROR: Winget no está disponible."
    exit
}

# ==========================================
# INSTALACIÓN DE APLICACIONES
# ==========================================

Write-Host ""
Write-Host "Instalando aplicaciones..."

$Apps = @(
    "Google.Chrome",
    "Google.GoogleDrive",
    "Tailscale.Tailscale",
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

Write-Host ""
Write-Host "Aplicando modo oscuro..."

New-Item `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes" `
    -Force | Out-Null

New-Item `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -Force | Out-Null

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -Name "AppsUseLightTheme" `
    -Value 0 `
    -Type DWord

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -Name "SystemUsesLightTheme" `
    -Value 0 `
    -Type DWord

# Forzar modo oscuro

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -Name "AppsUseLightTheme" `
    -Value 0 `
    -Type DWord `
    -Force

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -Name "SystemUsesLightTheme" `
    -Value 0 `
    -Type DWord `
    -Force

rundll32.exe user32.dll,UpdatePerUserSystemParameters
    # ==========================================
# EXPLORADOR
# ==========================================

Write-Host ""
Write-Host "Configurando explorador..."

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "HideFileExt" `
    -Value 0

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "Hidden" `
    -Value 1

# ==========================================
# BARRA DE TAREAS
# ==========================================

Write-Host ""
Write-Host "Configurando barra de tareas..."

# Centrada

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "TaskbarAl" `
    -Value 1 `
    -ErrorAction SilentlyContinue

# Ocultar búsqueda

New-Item `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
    -Force | Out-Null

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
    -Name "SearchboxTaskbarMode" `
    -Value 0 `
    -Type DWord `
    -ErrorAction SilentlyContinue

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
    -Name "SearchboxTaskbarModeCache" `
    -Value 0 `
    -Type DWord `
    -ErrorAction SilentlyContinue

# Ocultar Widgets

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "TaskbarDa" `
    -Value 0 `
    -ErrorAction SilentlyContinue

# Ocultar Vista de tareas

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "ShowTaskViewButton" `
    -Value 0 `
    -ErrorAction SilentlyContinue

# ==========================================
# COLOR DE ÉNFASIS VERDE
# ==========================================

Write-Host ""
Write-Host "Aplicando color de énfasis..."

New-Item `
    -Path "HKCU:\Software\Microsoft\Windows\DWM" `
    -Force | Out-Null

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\DWM" `
    -Name "AccentColor" `
    -Value 0xFF107C10 `
    -Type DWord `
    -ErrorAction SilentlyContinue

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\DWM" `
    -Name "ColorizationColor" `
    -Value 0xC4107C10 `
    -Type DWord `
    -ErrorAction SilentlyContinue

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\DWM" `
    -Name "EnableWindowColorization" `
    -Value 1 `
    -Type DWord `
    -ErrorAction SilentlyContinue

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\DWM" `
    -Name "ColorPrevalence" `
    -Value 1 `
    -Type DWord `
    -ErrorAction SilentlyContinue

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
    -Name "ColorPrevalence" `
    -Value 1 `
    -Type DWord `
    -ErrorAction SilentlyContinue

New-Item `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" `
    -Force | Out-Null

$AccentPalette = [byte[]](
0x95,0xEF,0x81,0x00,
0x45,0xE5,0x32,0x00,
0x19,0xA1,0x15,0x00,
0x10,0x7C,0x10,0x00,
0x0E,0x6D,0x0E,0x00,
0x08,0x4B,0x08,0x00,
0x03,0x2B,0x03,0x00,
0x4C,0x4A,0x48,0x00
)

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" `
    -Name "AccentPalette" `
    -Value $AccentPalette

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" `
    -Name "AccentColorMenu" `
    -Value 0xFF107C10 `
    -Type DWord

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" `
    -Name "StartColorMenu" `
    -Value 0xFF0E6D0E `
    -Type DWord

# ==========================================
# WIDGETS
# ==========================================

Write-Host ""
Write-Host "Desactivando Widgets..."

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "TaskbarDa" `
    -Value 0 `
    -ErrorAction SilentlyContinue

# ==========================================
# CURSOR CEREBRO
# ==========================================

Write-Host ""
Write-Host "Aplicando cursor CEREBRO..."

$ConfigFolder = "$env:TEMP\CEREBRO"
$CursorFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Cursors"

New-Item `
    -ItemType Directory `
    -Path $ConfigFolder `
    -Force | Out-Null

New-Item `
    -ItemType Directory `
    -Path $CursorFolder `
    -Force | Out-Null

# Descargar REG

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/t3st-scr1pt/CEREBRO-DEPLOY/main/configs/Accessibility.reg" `
    -OutFile "$ConfigFolder\Accessibility.reg"

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/t3st-scr1pt/CEREBRO-DEPLOY/main/configs/Cursors.reg" `
    -OutFile "$ConfigFolder\Cursors.reg"

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/t3st-scr1pt/CEREBRO-DEPLOY/main/configs/Cursors2.reg" `
    -OutFile "$ConfigFolder\Cursors2.reg"

# Descargar cursores

$CursorFiles = @(
    "arrow_eoa.cur",
    "busy_eoa.cur",
    "cross_eoa.cur",
    "ew_eoa.cur",
    "helpsel_eoa.cur",
    "ibeam_eoa.cur",
    "link_eoa.cur",
    "move_eoa.cur",
    "nesw_eoa.cur",
    "ns_eoa.cur",
    "nwse_eoa.cur",
    "pen_eoa.cur",
    "person_eoa.cur",
    "pin_eoa.cur",
    "unavail_eoa.cur",
    "up_eoa.cur",
    "wait_eoa.cur"
)

foreach ($Cursor in $CursorFiles)
{
    $SourceUrl = "https://raw.githubusercontent.com/t3st-scr1pt/CEREBRO-DEPLOY/main/configs/cursors/$Cursor"
    $DestinationFile = Join-Path $CursorFolder $Cursor

    try
    {
        Invoke-WebRequest `
            -Uri $SourceUrl `
            -OutFile $DestinationFile
    }
    catch
    {
        Write-Host "Error descargando $Cursor"
    }
}

# Importar configuración

reg import "$ConfigFolder\Accessibility.reg"
reg import "$ConfigFolder\Cursors.reg"
reg import "$ConfigFolder\Cursors2.reg"

# Forzar configuración

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Accessibility" `
    -Name "CursorType" `
    -Value 6 `
    -Type DWord

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Accessibility" `
    -Name "CursorColor" `
    -Value 65280 `
    -Type DWord

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Accessibility" `
    -Name "CursorSize" `
    -Value 2 `
    -Type DWord

Set-ItemProperty `
    -Path "HKCU:\Control Panel\Mouse" `
    -Name "MouseSensitivity" `
    -Value "13"

rundll32.exe user32.dll,UpdatePerUserSystemParameters

Start-Sleep 2
# ==========================================
# ENERGÍA
# ==========================================

Write-Host ""
Write-Host "Configurando energía..."

powercfg /hibernate off
powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-ac 0

# ==========================================
# WALLPAPER
# ==========================================

Write-Host ""
Write-Host "Aplicando wallpaper..."

try
{
    $WallpaperFolder = "$env:PUBLIC\Pictures"
    $WallpaperFile = "$WallpaperFolder\t3st-scr1pt.png"

    if (!(Test-Path $WallpaperFolder))
    {
        New-Item -ItemType Directory -Path $WallpaperFolder -Force | Out-Null
    }

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

    Write-Host "Wallpaper aplicado."
}
catch
{
    Write-Host "Error aplicando wallpaper."
}

# ==========================================
# REINICIAR EXPLORER
# ==========================================

Write-Host ""
Write-Host "Reiniciando Explorer..."

Stop-Process `
    -Name explorer `
    -Force `
    -ErrorAction SilentlyContinue

Start-Sleep 3

Start-Process explorer.exe