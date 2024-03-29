# minimize all windows
(New-Object -ComObject shell.application).toggleDesktop()

# download files
Invoke-WebRequest https://github.com/maosnumber1fan/mao/mao.jpg -O "$env:TEMP\mao.jpg"
Invoke-WebRequest https://github.com/maosnumber1fan/mao/mao.mp3 -O "$env:TEMP\mao.mp3"

# hide taskbar
$location = @{Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'; Name = 'Settings'}
$value = Get-ItemPropertyValue @location
$value[8] = 3
Set-ItemProperty @location $value
Stop-Process -Name Explorer -Force

# hide desktop icons
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
if (Test-Path -Path "$RegPath\HideIcons") {
    Set-ItemProperty -Path $RegPath -Name "HideIcons" -Value 1
} else {
    New-ItemProperty -Path $RegPath -Name "HideIcons" -Value 1 -PropertyType DWORD -Force
}
Stop-Process -Name explorer -Force
Start-Process explorer

# set wallpaper
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value 2 -Force
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices; 
public class Params { 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
$SPI_SETDESKWALLPAPER = 0x0014
$UpdateIniFile = 0x01
$SendChangeEvent = 0x02
$fWinIni = $UpdateIniFile -bor $SendChangeEvent
$ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, "$env:TEMP\mao.jpg", $fWinIni)

# play music
Add-Type -AssemblyName presentationCore
$mediaPlayer = New-Object system.windows.media.mediaplayer
$mediaPlayer.open("$env:TEMP\mao.mp3")
$mediaPlayer.Play()
