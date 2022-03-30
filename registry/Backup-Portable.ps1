<#
  .SYNOPSIS
  Backup portable/copyable files verbatim.

  .DESCRIPTION
  Backup-Portable.ps1 copies the given paths into highly-compressed archive.
  This script is a catch-all for files not discovered by Collate but needing backup.

  .PARAMETER Target
  Target folder for creating backup archive in.

  .PARAMETER Label
  Portable archive name.

  .PARAMETER Include
  Include array of paths with pattern syntax. Add whole path in the archive creation.

  .PARAMETER Exclude
  Exclude array of subpaths with pattern syntax. Remove subpaths from archive creation.

  .NOTES
  A mixture of Include and Exclude may be provided to backup selective directories/files.

  .LINK
  https://www.passeriform.com/product/Collate/ScriptRegistry/Backup-Portable.ps1

  .EXAMPLE
  PS> .\Backup-Portable.ps1 -Target C:\Backup\Target

  .EXAMPLE
  PS> .\Backup-Portable.ps1 -Target C:\Backup\Target                  \
        -Include "C:\NeededDir1", "C:\NeededDir2", "C:\NeededDir3"

  .EXAMPLE
  PS> .\Backup-Portable.ps1 -Target C:\Backup\Target                  \
        -Include "C:\NeededDir1", "C:\NeededDir2", "C:\NeededDir3"    \
        -Exclude "NeededDir1\NotNeededDir" "NeededDir2\NotNeededDir"
#>

param (
  [string]$Target = ".",

  [string]$Label = "portable",

  [string[]]$Include = @(),

  [string[]]$Exclude = @()
)

$Exclude=@($Exclude | % { "-xr!`"$_`"" })

7z.exe a -t7z -mx9 -up1q1r2x1y2z1w2 $Target/$Label.7z $Include[0..($Include.count - 1)] $Exclude[0..($Exclude.count - 1)]

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGFbiKzz8DbNUx56IrczMTYcn
# SkqgggNcMIIDWDCCAkCgAwIBAgIQRacYEB5ii4NLZI5TeJEIsjANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUOEuR7/6USCbIzh04msRRgMbWX0AwDQYJ
# KoZIhvcNAQEBBQAEggEALvSb5Tftvkw5wGIT3geGdaHJ761l3jPLFrqe6XOfL1Fj
# GfwWrFUdtdpDdEyIuX3xOKCm4fJNv9T7YstZpmNjU8goirmEBT8kjKO7ZpAhoY9s
# 0DDMQmuAKprKQNXgbZokIo2Jf5Ye1shc+ylZahqG8z0dB4LhXEuQW/ti/Cg9DbrV
# xn0FnA3aQpL7vPTDjI0sqH+9yhbszKSlcUhSgNSggBxl9J6bTc6l6zDdePQZYzQL
# 2ondnfZ79sVpXj1UccMQRz+9OH4AnHoB+wQi/FxKmxmNYp+86iQ1hN+8jIvEsHNm
# es37bTWhz9oKN+4OKhXy0ZXLw3wVilLCOMtF+TscWw==
# SIG # End signature block
