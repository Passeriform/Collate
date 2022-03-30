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
  [string]$Target = ".",

  [switch]$SustainVersion = $true,

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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUNLu+2G8La8lZxM4mURcIrhRM
# yZOgggNcMIIDWDCCAkCgAwIBAgIQRacYEB5ii4NLZI5TeJEIsjANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUZnmC1rzRgrhr/1yeXZZEy6OPuGswDQYJ
# KoZIhvcNAQEBBQAEggEAMuqBb52W13lmnx5OO2jKN0ow1ACoXXSM/JUg2D0xt+1R
# GFkivBdkXTJTBOYGaRkUFgrnMozHZdC55dxXOVE8c7bNIeiPs66mAD8Z48QFm7Xw
# wnNt6kpQ5ruMrF8xSykyXSk2FeqJdwOFQ+TxRk4EbXloMhjDhNtSrVXgOyGHly4f
# 3HzPKmB18GgufSvctuf+bs7DrdmNpbY/EBY3hRoSfAlfLgVgMx6M2muUDdw5wTi8
# YKgUw88Rj91USSs+OOtax1YYPNL6E6sBnXQ5aM7iq09zkxgo7smJWFr8qvuoK3Q7
# CVtZPCWaSgN6i5JdUFJPQGsfRWcd+62hv6cgsQq3ww==
# SIG # End signature block
