try { $null = Get-Command pshazz -ea stop; pshazz init } catch { }

$arc = if ([intptr]::size -eq 8) { "x64" } else { "x32" }

# Default Visual Studio Installer path
$VS_Installer = "C:\Program Files (x86)\Microsoft Visual Studio\Installer";

$VS_Path = "";
if (!(Get-Command Get-VSSetupInstance -ErrorAction SilentlyContinue)) { Install-Module VSSetup -Scope CurrentUser -Force }
if (Get-Command Get-VSSetupInstance -ErrorAction SilentlyContinue) { $VS_path = (Get-VSSetupInstance | Where-Object -Property DisplayName -Like "*2022").InstallationPath }
if ($VS_Path.Length -le 0) { try { $VS_Path = Invoke-Expression -Command "& '$VS_Installer\vswhere.exe' -legacy -latest -property installationPath" } catch { } }

$scoop_apps = (scoop list).Name;

# Environment Variables
# Change these to match your environment or create a my_settings.json file to override

$repos = "HD:\YOUR_REPOSITORIES\ROOT";
$dropbox = "HD:\YOUR_DROPBOX\ROOT";
$someserver = @{ Name = "some_server"; IP = "XXX.XXX.XXX.XXX"; MAC = "AA:BB:CC:DD:EE:FF"; };
$myServers = @($someserver);
$default_azurite_path = "d:\temp\azurite";
$now = $(Get-Date -UFormat %s);
$scoop_last_update = $now;
$update_scoop_every_days = 30;
$mySettingsExists = $false;

if (Test-Path -Path .\my_settings.json -PathType Leaf) {

    $mySettingsExists = $true;
    $MySettings = Get-Content -Path .\my_settings.json | ConvertFrom-Json

    $repos = $MySettings.MyRepos;
    $dropbox = $MySettings.MyDropbox;
    $myServers = $MySettings.MyServers;
    $someserver = ($MySettings.MyServers | Where-Object { $_.Name -eq "someserver" }) ;
    $default_azurite_path = $MySettings.DefaultAzuritePath;
    $scoop_last_update = $MySettings.ScoopLastUpdated;
    $update_scoop_every_days = $MySettings.ScoopUpdateEvery;
}

function Get-ClipboardText() {
    Add-Type -AssemblyName System.Windows.Forms
    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Multiline = $true
    $tb.Paste()
    $tb.Text
}

function Copy-SSHId([string]$userAtMachine, [string]$port = 22) {   
    if ($null -eq $userAtMachine -or $userAtMachine -eq "") {
        Write-Host -ForegroundColor Red "No <username>@<ssh server> specified";
        Write-Host "";
        Write-Host "Usage: ssh-copy-id <username>@<ssh server> <ssh port>";
        Write-Host "-------------------------------------------";
        Write-Host "<username> : SSH User";
        Write-Host "<ssh server>: SSH Server to copy ssh-key to";
        Write-Host "<ssh port>: Optional. SSH Server Port. Default value is 22.";
        Write-Host "-------------------------------------------";
        Write-Host "e.g ";
        Write-Host "  > ssh-copy-id nikolas@homesrv 22";
    }
    else {
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
}

function Send-WOLPacket ([string] $mac_address = $someserver.MAC) {
    Invoke-Expression -Command "& '$dropbox\tools\WOL\WakeMeOnLan.exe' /wakeup $mac_address"
}

function Start-Azurite ([string] $azurite_path = $default_azurite_path) {
    Invoke-Expression -Command "& '$VS_Path\Common7\IDE\Extensions\Microsoft\Azure Storage Emulator\azurite.exe' -l $azurite_path"
}

function Start-Telnet ([string] $telnet_host, [int] $telnet_port = 23) {
    #$telnet_url = "telnet://"+$telnet_host+":"+$telnet_port;
    #Invoke-Expression -Command "& '$dropbox\tools\putty.exe' $telnet_url"
    Invoke-Expression -Command "& '$dropbox\tools\putty.exe' -telnet -P $telnet_port $telnet_host"
}

function Start-RegEx ([string] $regex_pattern, [string] $test_string, [bool] $show_matches = $false) {
    if (($null -eq $regex_pattern -or $regex_pattern -eq "") -or ($null -eq $test_string -or $test_string -eq "")) {
        $msg = $null -eq $regex_pattern -or $regex_pattern -eq "" ? "No regex pattern specified!" : "No test string specified!";
        Write-Host -ForegroundColor Red $msg;
        Write-Host "";
        Write-Host "Usage: regex <pattern> <string> <show matches>";
        Write-Host "-------------------------------------------";
        Write-Host "<pattern> : The regular expression to use";
        Write-Host "<string>: The string to test against the regex";
        Write-Host "<show matches>: Optional. If true, the matches will be displayed. Values can be 1 or 0.";
        Write-Host "-------------------------------------------";
        Write-Host "e.g ";
        Write-Host "  > regex '^([0-9]*)([.,][0-9]+)?$' 99.9999 1";
        Write-Host "  > Match found!";
        Write-Host "  > 99.9999";
    }
    else {        
        $p = [Regex]::new($regex_pattern);
        $m = $p.Matches($test_string);

        if ($m.Length -gt 0) {
            Write-Host "Match found!"
            if ($show_matches) {
                foreach ($match in $m) {
                    Write-Host $match.Value
                }
            }
        }
        else {
            Write-Host "No matches found!"
        }
    }
}

Set-Alias -Name npp -Value $dropbox\tools\Notepad++\notepad++.exe -Option AllScope
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
Set-Alias -Name wol -Value Send-WOLPacket -Option AllScope
Set-Alias -Name radio -Value $dropbox\tools\RadioSure\RadioSure.exe -Option AllScope
Set-Alias -Name telnet -Value Start-Telnet -Option AllScope  #telnet 101.100.165.138 2020
Set-Alias -Name regex -Value Start-RegEx -Option AllScope
Set-Alias -Name ssh-copy-id -Value Copy-SSHId -Option AllScope

if ($VS_Path.Length -gt 0) { Set-Alias -Name azurite -Value Start-Azurite -Option AllScope }
if ($scoop_apps -contains 'git') { Set-Alias gpg (join-path (scoop prefix git) 'usr\bin\gpg.exe') }

# Update Scoop
if (($now - $scoop_last_update) -gt ($update_scoop_every_days * 24 * 60 * 60 )) {
    Write-Host "Scoop Update..." -ForegroundColor Magenta
    scoop update * && scoop cleanup -a -k

    # Save settings to my_settings.json    
    if ($mySettingsExists) {
        $MySettings.ScoopLastUpdated = $(Get-Date -UFormat %s);
        $MySettings | ConvertTo-Json | Out-File .\my_settings.json
    }
}
