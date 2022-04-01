<#
  .SYNOPSIS
  Creates gem list for globally installed gems.

  .DESCRIPTION
  Backup-Gem.ps1 collects gems installed by gem on global install
  based on Include and Exclude rules.

  .PARAMETER Target
  Target folder for creating backup document.

  .PARAMETER SustainVersion
  If true, keeps versions intact. If false, allows bumping to updated
  version of gems.

  .PARAMETER Include
  Include gems to be added to the backup list.

  .PARAMETER Exclude
  Exclude gems to be excluded from the backup list.

  .NOTES
  Include and Exclude rules can be used together to build the backup list.

  .LINK
  https://www.passeriform.com/product/Collate/ScriptRegistry/Backup-Gem.ps1

  .EXAMPLE
  PS> .\Backup-Gem.ps1 -Target C:\Backup\Target

  .EXAMPLE
  PS> .\Backup-Gem.ps1 -Target C:\Backup\Target -SustainVersion -Include "cgi", "delegate"

  .EXAMPLE
  PS> .\Backup-Gem.ps1 -Target C:\Backup\Target -Exclude "logger"
#>

param (
  [string]$Target = $PWD.path,

  [switch]$SustainVersion,

  [string[]]$Include = @(),

  [string[]]$Exclude = @()
)

$GemFile = "$Target\gem.list"

$IncludeExists = $Include.count -ne 0
$ExcludeExists = $Exclude.count -ne 0

if ($SustainVersion) {
  $Gems = gem list | % { $_ -replace '\s\((default: )?(?<version>[0-9]+.[0-9]+.[0-9]+)\)', ':${version}' }
} else {
  $Gems = gem list | % { $_ -replace '\s\((default: )?(?<version>[0-9]+.[0-9]+.[0-9]+)\)', '' }
}

if ($IncludeExists) {
  $Gems = $Gems | Select-String -Pattern $Include
}
if ($ExcludeExists) {
  $Gems = $Gems | Select-String -Pattern $Exclude -NotMatch
}

Set-Content $Gems -Path $GemFile

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU5yVFG1bJI15jKOVgeT+56YIG
# ZUqgggNcMIIDWDCCAkCgAwIBAgIQNJXPexLXZr1OqwRQr/pPkzANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUCBvWzwUW9DdF7aBEk431dcjGNmUwDQYJ
# KoZIhvcNAQEBBQAEggEATMcKYa4KswGoHP58dSQMWg6PfE4VVY5SpvDTMGbS4opz
# 5CDpPwUb2FHyeKTwddInHMMYKYS4Qu+dGJ4eMx7gVB8CvAUeSVRcN9ZEg502jZvH
# h57GJqS4Sd+iKDHXVPOw5ksVwPthhiQDf/8pcIfqgUH5YKpfvq5n+1TEg4XtxHnm
# 3gLVfLFKDVA2mtKy8opCd2kyipY4+/0nojkkZ+PHpQWrb7TXb4J3+SE/vkSd6qLY
# 3wS/xh/ZaJQD+Oi4yIaEVqZGwYq/diqFli9WjtHU/K5pD3NhEkhgCV+3RTAm692V
# /OBuRNsLoTl1IxmMLZg8ecwY9rH3ByyhuqqfhKqpeg==
# SIG # End signature block
