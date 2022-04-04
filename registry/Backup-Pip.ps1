<#
  .SYNOPSIS
  Creates freeze file list for global python packages.

  .DESCRIPTION
  Backup-Pip.ps1 collects packages installed by pip on global install
  or directory installs based on Include and Exclude rules.

  .PARAMETER Target
  Target folder for creating backup document.

  .PARAMETER SustainVersion
  If true, keeps versions intact. If false, allows bumping to updated
  version of packages.

  .PARAMETER Include
  Include pacakges to be added to the backup list.

  .PARAMETER Exclude
  Exclude pacakges to be excluded from the backup list.

  .NOTES
  Include and Exclude rules can be used together to build the backup list.

  .LINK
  https://www.passeriform.com/product/Collate/ScriptRegistry/Backup-Pip.ps1

  .EXAMPLE
  PS> .\Backup-Pip.ps1 -Target C:\Backup\Target

  .EXAMPLE
  PS> .\Backup-Pip.ps1 -Target C:\Backup\Target -SustainVersion -IncludeDir "C:\SomeDir" "D:\SomeOtherDir"

  .EXAMPLE
  PS> .\Backup-Pip.ps1 -Target C:\Backup\Target -SustainVersion -Include "psycopg2", "django", "distutils"

  .EXAMPLE
  PS> .\Backup-Pip.ps1 -Target C:\Backup\Target -Exclude "django"
#>

param (
  [string]$Target = $PWD.path,

  [switch]$SustainVersion,

  [string[]]$IncludeDir = @(),

  [string[]]$Include = @(),

  [string[]]$Exclude = @()
)

$RequirementsFile = "$Target\requirements.txt"

$IncludeExists = $Include.count -ne 0
$ExcludeExists = $Exclude.count -ne 0

$Packages = pip list --format freeze --no-index

if (!$SustainVersion) {
  $Packages = $Packages | % { ($_ -split "[=><~]+")[0] }
}

foreach ($Dir in $IncludeDir) {
  $PackagesForDir = pip list --path $Dir --format freeze --no-index
  if (!$SustainVersion) {
    $PackagesForDir = $Packages | % { ($_ -split "[=><~]+")[0] }
  }
  $Packages += $PackagesForDir
}

if ($IncludeExists) {
  $Packages = $Packages | Select-String -Pattern $Include
}
if ($ExcludeExists) {
  $Packages = $Packages | Select-String -Pattern $Exclude -NotMatch
}

Set-Content $Packages -Path $RequirementsFile

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBYYYo4XMaANnQHhxLLFskYhG
# RNigggNcMIIDWDCCAkCgAwIBAgIQNJXPexLXZr1OqwRQr/pPkzANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUlYx5BobgzLFypsfkaqzqF23sO+wwDQYJ
# KoZIhvcNAQEBBQAEggEAmFpHGLZ31BNfgn85ho0o+a8hk00Q4lyTWxcemuSQzJMP
# zzs1E+6b+tMfKr+fYS3PPRaJmJnLLULq8co4kPjIxY3g56cml47X/XWrnfw+qVTp
# ls3N/mqCE0pbhRYVoDbKlggilBqTV0S/kjFmWozbuszYTm3xUYoEdFN6lhqCnpYn
# s8YSSfXsZ17AHqLXACupbgJ9msy2dmtF9mn5xlOwMwMmyN0KT00Scf3nw6gKjdW/
# cC22UgRVg8n3XQOmCP+wf8qkyXRyIsrc6PPI21GLeTRoWwwWDtg0pdre2nfQcuh2
# 6y8rtoNs1RGghynMMh9CqlsKafJLbo2sUryqDpavzQ==
# SIG # End signature block
