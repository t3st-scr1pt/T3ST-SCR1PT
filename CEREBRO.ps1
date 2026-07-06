# ==========================================
# CEREBRO DEPLOY v1.4
# ==========================================

$ErrorActionPreference = "Continue"

# ==========================================
# SISTEMA DE LOGS
# ==========================================

$LogFolder = "C:\CEREBRO\Logs"

New-Item `
-ItemType Directory `
-Force `
-Path $LogFolder | Out-Null

$LogFile = "$LogFolder\install.log"
$StatusFile = "$LogFolder\estado.txt"

"INICIANDO DEPLOY" |
Out-File `
$StatusFile `
-Force

Start-Transcript `
-Path $LogFile `
-Append

# ==========================================
# COMIENZO DE DEPLOY
# ==========================================

Write-Host ""
Write-Host "====================================="
Write-Host "      CEREBRO DEPLOY INICIADO"
Write-Host "====================================="
Write-Host ""

# ==========================================
# ENERGÍA
# ==========================================

Write-Host ""
Write-Host "Configurando energia..."

powercfg -h off

powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-ac 0

powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-dc 0

# ==========================================
# COMPROBAR WINGET
# ==========================================

if (!(Get-Command winget -ErrorAction SilentlyContinue))
{
    Write-Host "ERROR: Winget no está disponible."

    Stop-Transcript

    exit
}

# ==========================================
# ESTRUCTURA CEREBRO
# ==========================================

"Creando estructura CEREBRO" |
Out-File `
$StatusFile `
-Force

Write-Host ""
Write-Host "Creando estructura CEREBRO..."

$Folders = @(
    "C:\CEREBRO",
    "C:\CEREBRO\Scripts",
    "C:\CEREBRO\Tools",
    "C:\CEREBRO\Wallpapers",
    "C:\CEREBRO\Configs"
)

foreach ($Folder in $Folders)
{
    New-Item `
        -ItemType Directory `
        -Path $Folder `
        -Force | Out-Null
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
    "7zip.7zip",
    "Microsoft.PowerToys",
    "Git.Git",
    "Microsoft.VisualStudioCode"
)

foreach ($App in $Apps)
{
    "Instalando $App" |
    Out-File `
    $StatusFile `
    -Force

    Write-Host ""
    Write-Host "Instalando $App..."

    winget install `
        --id $App `
        --exact `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    if($LASTEXITCODE -eq 0)
    {
        Write-Host "OK -> $App"
    }
    else
    {
        Write-Host "ERROR -> $App"
    }
}

# ==========================================
# RUSTDESK
# ==========================================

Write-Host ""
Write-Host "Instalando RustDesk..."

try
{
    $RustDeskInstaller = "$env:TEMP\RustDesk.exe"

    Invoke-WebRequest `
        -Uri "https://github.com/rustdesk/rustdesk/releases/latest/download/rustdesk-x86_64.exe" `
        -OutFile $RustDeskInstaller

    Start-Process `
        -FilePath $RustDeskInstaller `
        -ArgumentList "--silent-install" `
        -Wait

    Write-Host "OK -> RustDesk"
}
catch
{
    Write-Host "ERROR -> RustDesk"
}

"Configurando Windows" |
Out-File `
$StatusFile `
-Force

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

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f | Out-Null

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f | Out-Null

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v IsFeedsAvailable /t REG_DWORD /d 0 /f | Out-Null

# ==========================================
# CURSOR CEREBRO
# ==========================================

Write-Host ""
Write-Host "Aplicando cursor CEREBRO..."

$CursorFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Cursors"

New-Item `
    -ItemType Directory `
    -Path $CursorFolder `
    -Force | Out-Null

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

foreach ($File in $CursorFiles)
{
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/t3st-scr1pt/CEREBRO-DEPLOY/main/configs/cursors/$File" `
        -OutFile "$CursorFolder\$File"
}

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
    -Path "HKCU:\Control Panel\Cursors" `
    -Name "CursorBaseSize" `
    -Value 48 `
    -Type DWord

Set-ItemProperty `
    -Path "HKCU:\Control Panel\Mouse" `
    -Name "MouseSensitivity" `
    -Value "13"

rundll32.exe user32.dll,UpdatePerUserSystemParameters

Start-Sleep 2

# ==========================================
# FORZAR REFRESCO DEL CURSOR
# ==========================================

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class CursorRefresh
{
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool SystemParametersInfo(
        uint uiAction,
        uint uiParam,
        IntPtr pvParam,
        uint fWinIni
    );
}
"@

[CursorRefresh]::SystemParametersInfo(
    0x57,
    0,
    [IntPtr]::Zero,
    0x01 -bor 0x02
)

Start-Sleep 2

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
# PANTALLA DE BLOQUEO
# ==========================================

Write-Host ""
Write-Host "Configurando pantalla de bloqueo..." -ForegroundColor Green

$LockFolder = "$env:ProgramData\T3ST-SCR1PT"
$LockImage  = "$LockFolder\lockscreen.png"

New-Item -ItemType Directory `
    -Path $LockFolder `
    -Force | Out-Null

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/t3st-scr1pt/CEREBRO-DEPLOY/main/wallpapers/lockscreen.png" `
    -OutFile $LockImage

New-Item `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
    -Force | Out-Null

Set-ItemProperty `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
    -Name "LockScreenImage" `
    -Value $LockImage

gpupdate /force | Out-Null

Write-Host "Pantalla de bloqueo aplicada." -ForegroundColor Green

# ==========================================
# RESUMEN FINAL
# ==========================================

"COMPLETADO" |
Out-File `
$StatusFile `
-Force

@"
=================================
CEREBRO DEPLOY
=================================

Version: 1.4

Fecha: $(Get-Date)

Estado: COMPLETADO

Equipo: $env:COMPUTERNAME

"@ | Out-File `
"C:\CEREBRO\Logs\Resumen.txt"

# ==========================================
# REINICIAR EXPLORER
# ==========================================

rundll32.exe user32.dll,UpdatePerUserSystemParameters
Start-Sleep 2
Write-Host ""
Write-Host "Reiniciando Explorer..."

Stop-Process `
    -Name explorer `
    -Force `
    -ErrorAction SilentlyContinue

Start-Sleep 3

Start-Process explorer.exe

# ==========================================
# CERRAR APPS ABIERTAS
# ==========================================

Write-Host ""
Write-Host "Cerrando aplicaciones..."

@(
    "Code",
    "GitHubDesktop",
    "PowerToys.Settings",
    "PowerToys",
    "Tailscale",
    "GoogleDriveFS",
    "Chrome"
) | ForEach-Object {

    Get-Process $_ -ErrorAction SilentlyContinue |
    Stop-Process -Force -ErrorAction SilentlyContinue
}

# ==========================================
# PRIMER INICIO CEREBRO
# ==========================================

$PrimerInicio = @'
for($i=0;$i -lt 30;$i++)
{
    $DriveShortcut = Get-ChildItem `
    "G:\Mi unidad" `
    -Filter "*.lnk" `
    -ErrorAction SilentlyContinue |
    Where-Object {$_.BaseName -eq "T3ST-SCR1PT"} |
    Select-Object -First 1

    if($DriveShortcut)
    {
        break
    }

    Start-Sleep 10
}

if($DriveShortcut)
{
    $WshShell = New-Object -ComObject WScript.Shell

    $Link = $WshShell.CreateShortcut(
        $DriveShortcut.FullName
    )

    $DriveRoot = $Link.TargetPath

    $Script = "$DriveRoot\CEREBRO\Scripts\CEREBRO-DRIVE.ps1"

    if(Test-Path $Script)
    {
        Start-Process powershell `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$Script`""
    }
}

Remove-Item `
"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\CEREBRO-PRIMER-INICIO.lnk" `
-Force `
-ErrorAction SilentlyContinue
'@

$PrimerInicio |
Out-File `
"C:\CEREBRO\Scripts\PrimerInicio.ps1" `
-Force

$StartupFolder =
"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

$WshShell =
New-Object -ComObject WScript.Shell

$Shortcut =
$WshShell.CreateShortcut(
"$StartupFolder\CEREBRO-PRIMER-INICIO.lnk"
)

$Shortcut.TargetPath = "powershell.exe"

$Shortcut.Arguments =
'-ExecutionPolicy Bypass -File "C:\CEREBRO\Scripts\PrimerInicio.ps1"'

$Shortcut.Save()

Stop-Transcript

Start-Sleep 15

Restart-Computer -Force