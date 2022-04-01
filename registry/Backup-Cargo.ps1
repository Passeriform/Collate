<#
  .SYNOPSIS
  Creates cargo backup list for globally installed crates.

  .DESCRIPTION
  Backup-Cargo.ps1 collects crates installed by cargo on global install
  based on Include and Exclude rules.

  .PARAMETER Target
  Target folder for creating backup document.

  .PARAMETER SustainVersion
  If true, keeps versions intact. If false, allows bumping to updated
  version of crates.

  .PARAMETER Include
  Include crates to be added to the backup list.

  .PARAMETER Exclude
  Exclude crates to be excluded from the backup list.

  .NOTES
  Include and Exclude rules can be used together to build the backup list.

  .LINK
  https://www.passeriform.com/product/Collate/ScriptRegistry/Backup-Cargo.ps1

  .EXAMPLE
  PS> .\Backup-Cargo.ps1 -Target C:\Backup\Target

  .EXAMPLE
  PS> .\Backup-Cargo.ps1 -Target C:\Backup\Target -SustainVersion -Include "cargo-expand", "cargo-hack"

  .EXAMPLE
  PS> .\Backup-Cargo.ps1 -Target C:\Backup\Target -Exclude "custom_error"
#>

param (
  [string]$Target = $PWD.path,

  [switch]$SustainVersion,

  [string[]]$Include = @(),

  [string[]]$Exclude = @()
)

$CrateFile = "$Target\crate.list"

$IncludeExists = $Include.count -ne 0
$ExcludeExists = $Exclude.count -ne 0

if ($SustainVersion) {
  $Crates = cargo install --list | % { $idx = 1 } { if ($idx % 2) { $_ } $idx++ } | % { $_.replace(":", "") }
} else {
  $Crates = cargo install --list | % { $idx = 1 } { if ($idx % 2) { $_ } $idx++ } | % { $_.replace(":", "").split(" ")[0] }
}

if ($IncludeExists) {
  $Crates = $Crates | Select-String -Pattern $Include
}
if ($ExcludeExists) {
  $Crates = $Crates | Select-String -Pattern $Exclude -NotMatch
}

Set-Content $Crates -Path $CrateFile

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUaSYbvOBBV38bdSo1hrNpPHBF
# c7SgggNcMIIDWDCCAkCgAwIBAgIQNJXPexLXZr1OqwRQr/pPkzANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUD8z6C4eF/BUZ/6f8rbsbt4Q7u6QwDQYJ
# KoZIhvcNAQEBBQAEggEAjikHPUmgaWrK1sY9//xlu4AgcYnns06tIIL3sSpPNZBH
# 5XRDcNFaA0hwdJOixGQ11Z04laL6HJBjVA6OOk/o+V85G9pwhroRrRVCxFsc0q8e
# rzNIRjxxrHepCXxpu5bLD0F51YgI+L0cLceO3v30xdWLz4rumztjBJWb5tfrq2H8
# PKxWSjn7ShDIgCah+cRTHHm3qYEnRN97kpfW19bl96sbceTO+OR/5GwwAsVNJgcG
# G1jX7wnCIl8g8a1YQJa6n1vILsgNUvf/a2nLf5q8guknZLY5XZjIqg0+rjCPqE6P
# wfGmAsjfzxJ//smzmSuAvZNVxedhqIpLYze97KDs7w==
# SIG # End signature block
