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
  [string]$Target = $PWD.path,

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
  Invoke-Expression "$($PSScriptRoot)\Backup-Portable.ps1 -Target $Target -Include $($App.FullName) -Label $($App.Name)"
}

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUWHlDw0Cyp2a1XNWlIfe4ox2Y
# 8AegggNcMIIDWDCCAkCgAwIBAgIQNJXPexLXZr1OqwRQr/pPkzANBgkqhkiG9w0B
# AQUFADBEMRQwEgYDVQQKDAtQYXNzZXJpZm9ybTEsMCoGA1UEAwwjQ29sbGF0ZSBT
# Y3JpcHRzIFNpZ25pbmcgQ2VydGlmaWNhdGUwHhcNMjIwMzMxMjMyOTAyWhcNMjcw
# MzMxMjMzOTAxWjBEMRQwEgYDVQQKDAtQYXNzZXJpZm9ybTEsMCoGA1UEAwwjQ29s
# bGF0ZSBTY3JpcHRzIFNpZ25pbmcgQ2VydGlmaWNhdGUwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQDRLqdumz0gt9xhDnNuBrVCZqTXDXc4h4g7NKE4x2Z4
# Kbsxx1EdIZocLasL0rwa/4jqRmgyW7ackPuh0Dh8zZpSxY6lYbwbwvQ+qh9Y+9W1
# hCcsEqkPGZNnPSimjKJ/AKzKzABU920K6H+fkEAFfJir3keUbIAcDSVpcOQsd89S
# KpFQbbOaK9pmzs/4m0dD4XA45L6dU1c7hHjhaGOAT8gjI11klIxFQRYefNVUf4LM
# h4gY8OibDtmJXSyJrOY/C5f1WBGyoyK+2j5bdvPGe3bQtjADwvoOTUo/y/jNc8A2
# FtrmUeYW/iuM6BJYeSGxAGhUMXOasiffyHexFJUyYn8xAgMBAAGjRjBEMA4GA1Ud
# DwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUiKc7Kyei
# oMjvg0139GDYAdqOWhgwDQYJKoZIhvcNAQEFBQADggEBAM6uXk6KbzqVwKg31VI2
# qRU/AQfwpR6CrJ8ifGIaJIf7Sb8rjSsMwW1aRYrymYrIFjT17dObqNvMf9hoeONu
# pNnpaxIZlTnpo/aJBfl8f3cd2CvsA/CB+4aeCr5ntP3S1n9hUF+cRQS7OZbBGMFi
# GBXL7Y6lPMojP/uqwXhT30491hRp9D834GXrClvgvJlMBRwSM49q9zDsct+fck1+
# Y8kHg3c12hc1XTUKd95MyLo682JSSiFOgAvqysxawVS+Sx7nTq3qdYeI0L7Ti36T
# 6Zw8+ERQRn/6v14RE+0OycklX6Zp+beilddYYaEqupdzBngYN+Irs8BRFbLxGD0S
# Qb0xggH5MIIB9QIBATBYMEQxFDASBgNVBAoMC1Bhc3Nlcmlmb3JtMSwwKgYDVQQD
# DCNDb2xsYXRlIFNjcmlwdHMgU2lnbmluZyBDZXJ0aWZpY2F0ZQIQNJXPexLXZr1O
# qwRQr/pPkzAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUXFITS0CKQ744mxstBwIW+wrWrBowDQYJ
# KoZIhvcNAQEBBQAEggEAwJfAdbWXS34XW2wX1H6p+b4s3fNzsDBbsV2DLSZpvFIn
# XmA/w+FOOdoZnZe9++Vf6JpFYTBRl6yXBxsNGSOi9wKC/b4sJRRTGulZaJp7gKRF
# uXP+Rx8XTWUGcFuAuZFgpWS+eYR7Gs6g2YFUwQdTwMNZSoJX4rYubwxuQ7IQRqW2
# UQodS/K+cQybEW0NUpX+xiCLrxuF0PLIlB19TAPFVEOeu++vNbIKG6ufM/NnDjKO
# SpX7aSLrRZa5iJSpEJgmqzl9e5NJObrtNo4Lk5VlA31l4c34gcuDKR5sJXZs7fsg
# WRhkYMrZgiRvEY9OBerXKivpPCaWoaFPNQ963bziGQ==
# SIG # End signature block
