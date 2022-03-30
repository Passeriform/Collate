<#
  .SYNOPSIS
  Creates steam backup archive.

  .DESCRIPTION
  Backup-Steam.ps1 finds installed steam apps and creates a backup archive.

  .PARAMETER Target
  Target folder for creating backup archives.

  .PARAMETER Include
  Include apps to list of archives.

  .PARAMETER Exclude
  Exclude apps from list of archives

  .NOTES
  Include and Exclude rules can be used together to create archive list.

  .LINK
  https://www.passeriform.com/product/Collate/ScriptRegistry/Backup-Steam.ps1

  .EXAMPLE
  PS> .\Backup-Steam.ps1 -Target C:\Backup\Target

  .EXAMPLE
  PS> .\Backup-Steam.ps1 -Target C:\Backup\Target -Include "Witcher", "Warframe"

  .EXAMPLE
  PS> .\Backup-Steam.ps1 -Target C:\Backup\Target -Exclude "Blender"
#>

param (
  [string]$Target = ".",

  [string[]]$Include = @(),

  [string[]]$Exclude = @()
)

$SteamInstallPath = (Get-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Valve\Steam\ -Name InstallPath).InstallPath
$CommonFilesPath = "$SteamInstallPath\steamapps\common"

$Apps = Get-ChildItem $CommonFilesPath

$IncludeExists = $Include.count -ne 0
$ExcludeExists = $Exclude.count -ne 0

if ($IncludeExists) {
  $Apps = $Apps | ? { $_.FullName -imatch $Include }
}
if ($ExcludeExists) {
  $Apps = $Apps | ? { $_.FullName -inotmatch $Exclude }
}

ForEach ($App in $Apps) {
  Invoke-Expression "Backup-Portable.ps1 -Target $Target -Include $($App.FullName) -Label $($App.Name)"
}

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU3Fz/gpBDrzSZBlhzaI6a/9Gc
# /5qgggNcMIIDWDCCAkCgAwIBAgIQRacYEB5ii4NLZI5TeJEIsjANBgkqhkiG9w0B
# AQUFADBEMRQwEgYDVQQKDAtQYXNzZXJpZm9ybTEsMCoGA1UEAwwjQ29sbGF0ZSBT
# Y3JpcHRzIFNpZ25pbmcgQ2VydGlmaWNhdGUwHhcNMjIwMzMwMTAxNzE3WhcNMjcw
# MzMwMTAyNzE2WjBEMRQwEgYDVQQKDAtQYXNzZXJpZm9ybTEsMCoGA1UEAwwjQ29s
# bGF0ZSBTY3JpcHRzIFNpZ25pbmcgQ2VydGlmaWNhdGUwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQC4nMgpBe0CbGz540bsmQDsFMoMJ61mFJG6YlfuPMtT
# 36QeD6Xqhd3bnWXqkkkpIgqivSfCxvMW5j0y3/bxDek4OEU6BAN9VXXvIv6spj9W
# w2GzhjZb1Q/N8cjifwwWF59xkX6bs4pN/kf8eRwmh8hY7xqqaUhEXQx+fGWdcZw7
# NbmBUvjUboizgsOAk4qLZyI4xfGG5L0uEEEPmToDifwUP7PN8Y1XUUjnNrtxjRYP
# cUdZ7As6I/iE0+ZuVErJw+e5rAeQE0g3LWiyi5x0HgNmj6FYb+ZcYpRPm5N9GY7A
# ohDmz93Ak4baqoQkKqnhybJ7dq9swgbEenFSv3i3/45hAgMBAAGjRjBEMA4GA1Ud
# DwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUvfRcd8xX
# vscCsTQtiOBBrXUTKagwDQYJKoZIhvcNAQEFBQADggEBAGeiimIuUU6gUH7Mu1rb
# EYlnfZZmwzsJPyY87TR53EQxrWce+6A/hjekJTfXUvc/B0FhNgN+GS7TxEfIRkiw
# 11ozpdSqgSsrIrnNVsS5LpuW9Ut0Wi8omXw3no8Q9UCXHxdUlDjLsE9LO1fWrNgm
# m6KkL5dCB3RroMlvrdRwjiHBMmUKAUaqEcPI2evNjh8x/ZUjMcvXsu0238xulRYN
# wD/I9HFhZZ/4qAz7RtG4o1I1+YSavG2SzOmbOd8l+JJX/566XNVm/U4HJilGTwTN
# KVrbgxWxA4MnpF6KIxhMCfC/MwRx7s/RPymiQf3NPzKROWp/cynfMDh8QxHa3VF8
# M0gxggH5MIIB9QIBATBYMEQxFDASBgNVBAoMC1Bhc3Nlcmlmb3JtMSwwKgYDVQQD
# DCNDb2xsYXRlIFNjcmlwdHMgU2lnbmluZyBDZXJ0aWZpY2F0ZQIQRacYEB5ii4NL
# ZI5TeJEIsjAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUwMIHtdVnLwfPYMfI65iIUVwoo8YwDQYJ
# KoZIhvcNAQEBBQAEggEAbO1psdkPpUkHRjNOxSDImme5lXeWVthyrDPWYI6/ctZm
# zaudzVvorzYRuVwTqTgthgTTEERB+7XC1ljmosRc17m4rIAZ46YysaVmSyHVNSkw
# BfIQngpNoTgA7+rAE8/GYZI/Fj+pnpdPqsNI8KZwKnOMN8PBjqpDSbYV8VrnJWpU
# tPf/Fcy2LSXBkx3R0mZHN0OF301OU20a5EhyQt0YR2HOWSeoEWUR8bciXnanI5qY
# EM0nhV6Wb2i1z/Q9qPPDR+QBjhHlrygMM1MfwgmwQTc4pf3l9tIvu1kJmOC51xZi
# 72qqk5j1addA5XV8bRKV2WegCu1tyZYoQrzSAcFgjw==
# SIG # End signature block
