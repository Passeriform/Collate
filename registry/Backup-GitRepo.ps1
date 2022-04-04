<#
  .SYNOPSIS
  Scans and backs up git repositories.

  .DESCRIPTION
  Backup-GitRepo.ps1 scans and collects git repositories based on Include and Exclude rules.

  .PARAMETER Target
  Target folder for creating repo backups.

  .PARAMETER ScanRoot
  Root folder to start repo scanning from.

  .PARAMETER Recurse
  If true, recurses nested directories. Implies to store repositories inside repositories
  without support for submodules. If false, stops search at the outermost git directory

  .PARAMETER Depth
  Number of nested depth to recurse.

  .PARAMETER Exclude
  Include repositories to be backed up.

  .NOTES
  Include and Exclude rules can be used together to configure which repositories to backup.

  .LINK
  https://www.passeriform.com/product/Collate/ScriptRegistry/Backup-GitRepo.ps1

  .EXAMPLE
  PS> .\Backup-GitRepo.ps1 -Target C:\Backup\Target  "D:"

  .EXAMPLE
  PS> .\Backup-GitRepo.ps1 -Target C:\Backup\Target -Include "AddedRepos/*", "ExtraRepos/*" "F:"

  .EXAMPLE
  PS> .\Backup-GitRepo.ps1 -Target C:\Backup\Target -Exclude "bat", "gps-*" "D:"
#>

param (
  [string]$Target = $(Get-Location),

  [switch]$Recurse,
  
  [int]$Depth,

  [string[]]$Exclude = @(),

  [Parameter(Mandatory, Position=0)]
  [string]$ScanRoot
)

function wildcardArrayForDepth($Depth) {
    $wildcardArray = @()
    1..($depth + 1) | % { $wildcardArray += "\*" * $_ }
    return $wildcardArray
}

$IncludeExists = $Include.count -ne 0
$ExcludeExists = $Exclude.count -ne 0

if ($Recurse) {
  $SearchPaths = $(wildcardArrayForDepth -Depth $Depth) | % { "$ScanRoot$_" }
  $GitRepos = Get-ChildItem $SearchPaths -Force -ErrorAction SilentlyContinue -Filter ".git" | % { $_.Parent }
} else {
  # Direct repository folder provided
  $GitRepos = Get-ChildItem -Path "$ScanRoot\*" -Force -ErrorAction SilentlyContinue -Filter ".git" | % { $_.Parent }
}

if ($ExcludeExists) {
  $GitRepos = $GitRepos | ? { $_.FullName -inotmatch $Exclude }
}

ForEach ($Repo in $GitRepos) {
  $RepoBackupTarget = "$Target\$($Repo.Name)"

  # Create backup directory
  MD -Force $RepoBackupTarget

  Push-Location $Repo.FullName

  # Bundle
  git bundle create "$RepoBackupTarget\$($Repo.Name).bundle" --all

  # Stashes
  git stash list | % {
    $Name, $Message, $Head = ($_ -split ": ")
    $Idx = ($name -split "@")[1]

    $Content = (git stash show -p "stash@$idx")
    $FileName = "$RepoBackupTarget\${name}#${message}#${head}"

    [IO.File]::WriteAllLines($Filename, $Content)
  }

  # Staged/cache
  [IO.File]::WriteAllLines("$RepoBackupTarget\staged.patch", (git diff --cached --patch))

  # Unstaged
  [IO.File]::WriteAllLines("$RepoBackupTarget\unstaged.patch", (git diff --patch))

  $TemporaryStashMessage = "[Collate] A temporary stash created by collate. Pop if left over while backup process."

  # Untracked
  git stash -m $TemporaryStashMessage

  git add .
  [IO.File]::WriteAllLines("$RepoBackupTarget\untracked.patch", (git diff --cached --patch))
  git reset

  $TemporaryStashName = (git stash list | ? { $_ -imatch $TemporaryStashMessage } | % { ($_ -split ": ")[0] })

  if ($TemporaryStashMessage -ne $null) {
    git stash pop $TemporaryStashName --index
  }

  Pop-Location
}

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUxTMkfU421/DotdGYQbS3Urni
# DeygggNcMIIDWDCCAkCgAwIBAgIQNJXPexLXZr1OqwRQr/pPkzANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUvBpIakZDkSwp/YZhkMu6/L5QVdIwDQYJ
# KoZIhvcNAQEBBQAEggEAoN6ZAU554brH/OU4KgYG9cavxzs4CDQ1gv8amo8UuJ8M
# 4wpH5z3//ofm6+rvxjYQmCZsazGkVGXenPqa5yMA+/Jj+/eln9io7XiaYaM6PlWW
# 5n4PaAyFPxmk6WJUMFXw1Qu3glDMxf9ApVZXtZbvJlVSfhsCyMpJRuWrOsSGImup
# 2CFSn0cizcGhwSbnWMGoRqJRmA/2V4iQYx6j1LJnle+/cLot84YdBry95DymessZ
# WUZBsGozpn1bwL8UNulmtgQjXovefynXJVj6/2vAeAlsGJKCucLT/zBB0u4VhXTt
# CiJPJMSp0S4oHfgohancA7XkcAqm1np/4SQSk+Vd/A==
# SIG # End signature block
