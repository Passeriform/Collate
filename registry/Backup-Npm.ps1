<#
  .SYNOPSIS
  Creates npm package list for globally installed packages.

  .DESCRIPTION
  Backup-Npm.ps1 collects packages installed by npm on global install
  based on Include and Exclude rules.

  .PARAMETER Target
  Target folder for creating backup document.

  .PARAMETER SustainVersion
  If true, keeps versions intact. If false, allows bumping to updated
  version of pacakges.

  .PARAMETER Include
  Packages to be included to the backup list.

  .PARAMETER Exclude
  Packages to be excluded from the backup list.

  .NOTES
  Include and Exclude rules can be used together to build the backup list.

  .LINK
  https://www.passeriform.com/product/Collate/ScriptRegistry/Backup-Npm.ps1

  .EXAMPLE
  PS> .\Backup-Npm.ps1 -Target C:\Backup\Target

  .EXAMPLE
  PS> .\Backup-Npm.ps1 -Target C:\Backup\Target -SustainVersion -Include "npm-expand", "npm-hack"

  .EXAMPLE
  PS> .\Backup-Npm.ps1 -Target C:\Backup\Target -Exclude "custom_error"
#>

param (
  [string]$Target = $PWD.path,

  [switch]$SustainVersion,

  [string[]]$Include = @(),

  [string[]]$Exclude = @()
)

$PackageFile = "$Target\npm.list"

$IncludeExists = $Include.count -ne 0
$ExcludeExists = $Exclude.count -ne 0

if ($SustainVersion) {
    $Packages = (npm list -g --depth=0 --json | ConvertFrom-Json).dependencies.PSObject.Properties | % { "$($_.Name)@$($_.Value.version)" }
} else {
    $Packages = (npm list -g --depth=0 --json | ConvertFrom-Json).dependencies.PSObject.Properties | % { $_.Name }
}

if ($IncludeExists) {
  $Packages = $Packages | Select-String -Pattern $Include
}
if ($ExcludeExists) {
  $Packages = $Packages | Select-String -Pattern $Exclude -NotMatch
}

Set-Content $Packages -Path $PackageFile

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUinfGxmS20U24U57HrFJ/A5M6
# 4sSgggNcMIIDWDCCAkCgAwIBAgIQNJXPexLXZr1OqwRQr/pPkzANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUa03NOmUX3lrZWQVAZbeC+QRPCTMwDQYJ
# KoZIhvcNAQEBBQAEggEAfztmrCuHp6jGs2CX+0kv84tQP1rktVb9QJW5xN0nqV5E
# T5XY/nqDAc2u6HF5Svt9mxNq/xr7tt4lhajf+bE+pMMowmyJAYMVJ0YBoFK/QJme
# TzELp2znLFpi5YPIMv8M3KlmPZdlZq9YOIKdECU1F9qpldztr8QfaYeWQ9bS5LeU
# D6OVRgP9s75fHzjegk7nDpV7JoeXhB/DFkYvIkMdxNXun5QuzEv4jnA9dAEOngtn
# T4OuK4KEX8pOawiRARKCvtJ/frjAgMUVTvT89FOL59URCdGEa2/NYBUmlcx2r8Vc
# BrKehiIlHLEqtUpp8o5Z8Ohny5iVgSJCwgAZbEXPIA==
# SIG # End signature block
