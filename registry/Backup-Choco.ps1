<#
  .SYNOPSIS
  Creates choco backup list for installed packages.

  .DESCRIPTION
  Backup-Choco.ps1 backs up choco packages based on Keep or Exclude rules.

  .PARAMETER Target
  Target folder for creating backup document.

  .PARAMETER Keep
  Include crates to be added to the backup list.

  .PARAMETER Exclude
  Exclude crates to be excluded from the backup list.

  .NOTES
  Keep and Exclude rules are exclusive and must be used separately.

  .LINK
  https://www.passeriform.com/product/Collate/ScriptRegistry/Backup-Choco.ps1

  .EXAMPLE
  PS> .\Backup-Choco.ps1 -Target C:\Backup\Target

  .EXAMPLE
  PS> .\Backup-Choco.ps1 -Target C:\Backup\Target -Keep "7zip", "git"

  .EXAMPLE
  PS> .\Backup-Choco.ps1 -Target C:\Backup\Target -Exclude "KB*"
#>

param (
  [string]$Target = $PWD.path,

  [string[]]$Keep = @(),

  [string[]]$Exclude = @()
)

$PackageFile = "$Target\package.xml"

$KeepExists = $Keep.count -ne 0
$ExcludeExists = $Exclude.count -ne 0

$Packages = choco list -lo -r | % { $_ -split "\|" | select -first 1 }

if ($KeepExists) {
  $Packages = $Packages | Select-String -Pattern $Keep
}
if ($ExcludeExists) {
  $Packages = $Packages | Select-String -Pattern $Exclude -NotMatch
}

$PackageXml = ""

$Packages | % { $PackageXml += "`n`t<package id=""$_"" />" }

Set-Content "<?xml version=`"1.0`" encoding=`"utf-8`"?>`n<packages>$PackageXml`n</packages>" -Path $PackageFile

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUbFMBZyPExwuhhdFd3SRzue3A
# 4FGgggNcMIIDWDCCAkCgAwIBAgIQNJXPexLXZr1OqwRQr/pPkzANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUR6LtiVZOd668YBI+nSIXWW6OBUAwDQYJ
# KoZIhvcNAQEBBQAEggEAOBzljtYwh5xNqSB8LGtFejUvcZ0ILdgCDYlWKXG73P5F
# icMqmi4jUqhOie6pgiWj2zCPekv7hgw4eGM0jYlElPdWb5RJsnSf40IHKNzgK08T
# bCMr3V5+aB3kyJZGLwajHlkPKcEgCmNOW7F8F62XegX0TzcVZmkZMVYKnM6+Rqs8
# a9OVUrHFEOgtJ28aOrMtmYopAMQTbEWETOWd2w7LcX0Mse2V53gbDCCD18B5nrrK
# PDJM0wDGEGmkzyrwNZ/lXXIS6A23ggwzo+U1RSGuPHJjuZuai7h2oRxmbQSzTiuc
# 2HBvz1ptU0NdERBQrayE/wj9rTQHkQ4rxwOP/Lar5w==
# SIG # End signature block
