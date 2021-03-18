﻿try { $null = gcm pshazz -ea stop; pshazz init 'default' } catch { }
$arc = if([intptr]::size -eq 8) { "x64" } else { "x32" }
function Get-ClipboardText()
{
    Add-Type -AssemblyName System.Windows.Forms
    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Multiline = $true
    $tb.Paste()
    $tb.Text
}
#Set-Alias -Name npp -Value D:\Dropbox\tools\Notepad++\notepad++.exe -Option AllScope
#Set-Alias -Name sub -Value D:\Dropbox\tools\sublime3\$($arc)\sublime_text.exe -Option AllScope
#Set-Alias -Name code -Value D:\Dropbox\tools\VSCode\Code.exe -Option AllScope
Set-Alias -Name ll -Value Get-ChildItem -Option AllScope
Set-Alias -Name l -Value Get-ChildItem -Option AllScope
Set-Alias -Name rc -Value C:\Windows\System32\Robocopy.exe -Option AllScope
Set-Alias -Name die -Value Stop-Computer -Option AllScope
Set-Alias -Name '..' -Value cd.. -Option AllScope
Set-Alias -Name paste -Value Get-ClipboardText -Option AllScope
