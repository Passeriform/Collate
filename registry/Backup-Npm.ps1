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
  [string]$Target = ".",

  [switch]$SustainVersion = $true,

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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUxSw6ftJBxCwvJp8ShNLYLynj
# uj2gggNcMIIDWDCCAkCgAwIBAgIQRacYEB5ii4NLZI5TeJEIsjANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUnrM/GmWh3KovJmtNyxSU72m2eVowDQYJ
# KoZIhvcNAQEBBQAEggEAtr23uUK77zPU3eJEwn0kw/NPHWk9Y8jJ4T6g7HR/mbPI
# EYb/aNcwHVPvPAvGbKYPo4lQbJYWzEqcaTrgPJLzGSZ9x12H5Z8zmYtPJreAHi8G
# RsvAFpYS2wLGef3mtpQa1EArKPztZMgyQKimnJ+FJXjbyZvfmJrqgR8rbfAzSQIJ
# eIwdwZI3uiM5L0YMNnOwKBHEEj1Yh6lW6EzEfjDHDqHEIkWgniiWfwySxlu2C5m+
# VR6EJ6VKAqN7HDsgOqSvuNb0sRXaVnWoC3/NVrWJGOTz3KkgU594EyF9jJEHftNL
# oOwSHHJJoeqUkeQwuwIzq6cEo7R1Ry2TjNTA6YlKMw==
# SIG # End signature block
