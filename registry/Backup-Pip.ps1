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
  [string]$Target = ".",

  [switch]$SustainVersion = $true,

  [string[]]$IncludeDir = @(),

  [string[]]$Include = @(),

  [string[]]$Exclude = @()
)

$RequirementsFile = "$Target\requirements.txt"

$IncludeExists = $Include.count -ne 0
$ExcludeExists = $Exclude.count -ne 0

$Packages = pip list --format freeze --no-index

if (!$SustainVersion) {
  $Packages = $Packages | % { ($_ -split "[=><~]*")[0] }
}

foreach ($Dir in $IncludeDir) {
  $PackagesForDir = pip list --path $Dir --format freeze --no-index
  if (!$SustainVersion) {
    $PackagesForDir = $Packages | % { ($_ -split "[=><~]*")[0] }
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUPkLWI9t2m3uO2qeZwEqerAGP
# CeugggNcMIIDWDCCAkCgAwIBAgIQRacYEB5ii4NLZI5TeJEIsjANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUAmPnso8PKZCqkhRKe4tcTKlXfPcwDQYJ
# KoZIhvcNAQEBBQAEggEAKoBa6OzlN3ffbnP46eqFYQIy5+yK3Z8M+B8wRj3W8eBH
# xUQGWexXebSrCbMq18Ewzk9935aGC5UcCG8dnbf+DvHosaZOSRzn7EMnyFWQUBL1
# rBjOZ3uASdzWjklmof9LF8bHNfmBNjDHUH4PGBHoaMy6r1h9Tg08q3FAFWdesLI7
# 3BlNMwkLlpZw1QHPc8F/dSrqe8Ept2RwtWo936toDSyVODyKkWC7IQtT6hfPEqic
# gn4UivzhNCnTGq2uCcOOtHkIKOv8s6w1lMg1AsdlFEmrMAqVNPR+VL5xP3bQMraJ
# b7FiH+9zZqkJnULhrtnrkvb6fiCm+U/P25wpyQPs6w==
# SIG # End signature block
