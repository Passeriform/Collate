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
  [string]$target = ".",

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

Set-Content "<?xml version=`"1.0`" encoding=`"utf-8`"?>`n<packages>$PackageXml`n</packages>" -Path $target

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUHWwal2EnqVtoW+FsR0bpTZHW
# sCOgggNcMIIDWDCCAkCgAwIBAgIQRacYEB5ii4NLZI5TeJEIsjANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUkuEOUglg6NnOfSsB+d8JUWhJY4IwDQYJ
# KoZIhvcNAQEBBQAEggEATYyM/QklQYP9PPblXCgd9VdoYFE8iJ8/piwAGvip5IML
# YfUcMrK+/6Ct3kgpDWjdmG0oRp4RVP04XmQpdqE08Djw59epJP0m5JhSPi6X1Gsf
# xGpRy7Qsd9zc22WTDUqAC7T7YBa+u0PRHyzxFKTpMfO3vH4ewPfOrHFvyhALALQM
# 4z8RDK7DS/plDXTUxLP5/d5XBQADkOGXyq7ITuw6KA0WfoK7t6AkymA4MyVdZTkK
# wBsKoUaHgp7HJ+LtPM6c2mvHVvGuvp9ceFXtXXNEq1bilDQzfdEmaTZ4utOeN0Nb
# +9A7uCCJFP0yu+vR7CeJ1c1oYbtl7zY9JOsjGVOhpA==
# SIG # End signature block
