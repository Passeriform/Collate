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
  [string]$Target = $PWD.path,

  [string]$Label = "portable",

  [string[]]$Include = @(),

  [string[]]$Exclude = @()
)

$Exclude=@($Exclude | % { "-xr!`"$_`"" })

7zz a -t7z -mx9 -up1q1r2x1y2z1w2 $Target/$Label.7z $Include[0..($Include.count - 1)] $Exclude[0..($Exclude.count - 1)]

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU5f8V45TC1ttu1XA1qOkaFVl8
# 1WqgggNcMIIDWDCCAkCgAwIBAgIQNJXPexLXZr1OqwRQr/pPkzANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUY7LrwdBKbJnntsU5INE6Hv/o+XUwDQYJ
# KoZIhvcNAQEBBQAEggEArFTfC11kGotwUDcio9RcdXQienn+JJ3NW6pc+lG2cIOs
# U2+OrZUrtKPz3WGZF6GYH+rjCw7awiZnn8XZTFh/ehiUublslPbMULaVECWVBKnz
# msOj494KIkEZuuhPAvpXiW//4WBGxkd717w7QqE8SrfO0f/SkWUeRdsHyQmNvW3p
# SLOZ6CNrc0PKdS8LDV8IL4FmH5AHMHxAvsdEjeyVDTgdRU5ZLX4ha1EpnI6OvPzq
# NHzxlM/i1VDC4FHwcoEZjSW52ssz7JLJfitdzBNCPlpGd0tUO7VvvGbWtuX22Jdv
# F02eSdDrMi8ARasGvwrJ9dX0dwQOf3EAUBkimGeX9A==
# SIG # End signature block
