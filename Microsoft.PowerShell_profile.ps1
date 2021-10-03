try { $null = Get-Command pshazz -ea stop; pshazz init } catch { }

$arc = if([intptr]::size -eq 8) { "x64" } else { "x32" }
$dropbox = "H:\Dropbox\Path"
$homesrv = @{ Name = "myserver"; IP = "XXX.XXX.XXX.XXX"; MAC = "AA:BB:CC:DD:EE:FF"; }

function Get-ClipboardText()
{
    Add-Type -AssemblyName System.Windows.Forms
    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Multiline = $true
    $tb.Paste()
    $tb.Text
}

function ssh-copy-id([string]$userAtMachine, [string]$port = 22) 
{   
    # Get the generated public key
    $key = "$ENV:USERPROFILE" + "/.ssh/id_rsa.pub"
    # Verify that it exists
    if (!(Test-Path "$key")) {
        # Alert user
        Write-Error "ERROR: '$key' does not exist!"            
    }
    else {	
        # Copy the public key across
        & Get-Content "$key" | ssh $userAtMachine -p $port "umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys || exit 1"      
    }
}

function Copy-MyProfile([string]$dbPath = $dropbox)
{
    if (!(Test-Path -Path $PROFILE))
    {
        New-Item -ItemType File -Path $PROFILE -Force
    }
    
    Copy-Item -Path "$dbPath\path\to\my\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
}

function wol ([string] $mac_address = $homesrv.MAC)
{
    Invoke-Expression -Command "$dropbox\tools\WOL\WakeMeOnLan.exe /wakeup $mac_address"
}

Set-Alias -Name npp -Value $dropbox\tools\Notepad++\notepad++.exe -Option AllScope
#Set-Alias -Name sub -Value $dropbox\tools\sublime3\$($arc)\sublime_text.exe -Option AllScope
Set-Alias -Name code -Value $dropbox\tools\VSCode\Code.exe -Option AllScope
Set-Alias -Name ll -Value Get-ChildItem -Option AllScope
Set-Alias -Name l -Value Get-ChildItem -Option AllScope
Set-Alias -Name rc -Value C:\Windows\System32\Robocopy.exe -Option AllScope
Set-Alias -Name die -Value Stop-Computer -Option AllScope
Set-Alias -Name '..' -Value cd.. -Option AllScope
Set-Alias -Name paste -Value Get-ClipboardText -Option AllScope
Set-Alias -Name ports -Value $dropbox\tools\CurrPorts\cports.exe -Option AllScope
Set-Alias -Name keepass -Value $dropbox\tools\Keepass\Keepass.exe -Option AllScope
Set-Alias -Name uninstall -Value $dropbox\tools\RevoUninstaller\RevoUPort.exe -Option AllScope
Set-Alias -Name merge -Value $dropbox\tools\WinMerge\WinMergeU.exe -Option AllScope
#Set-Alias -Name wol -Value $dropbox\tools\WOL\wol.exe -Option AllScope
Set-Alias -Name radio -Value $dropbox\tools\RadioSure\RadioSure.exe -Option AllScope
