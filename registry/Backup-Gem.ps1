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
  [string]$Target = ".",

  [switch]$SustainVersion = $true,

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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUvEeC+2nIChAojOiUjmjKBiwH
# hwGgggNcMIIDWDCCAkCgAwIBAgIQRacYEB5ii4NLZI5TeJEIsjANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUl2ijYTml+nDQHpdjA9fcRHSUAeMwDQYJ
# KoZIhvcNAQEBBQAEggEAlsY+FP3H74HEFp+DIcFtwhZbEirI6bOorawLV82khcA/
# X0FvrV4NtcZYUNrkUJs9uDSLLylYobI5On8wYqA6f4Mxx2gv7/S3LbT+z+M+I10G
# VczJDYztnqPR0fEjtPpJZs8czDcP5hC701Aasl/O1IHbLXpUSZl/j/8L5ZtQr/pW
# GZaiIZGvWecr/+3K7cjGcNeVePqHa9fNMv6CCIWgxk02II1BFSVClvU0egErhy/6
# CrXofUTe0tdcfE0cNoiP9JXD7R6b624p+U/6ZBhtHDEZFHuHk2Uxm/eUfJTzdavE
# RN5+KONvlFH1LpB+1faUw2hlwtP3g+BQM4VgDTPnvQ==
# SIG # End signature block
