##### Internal methods ####

$CertificateSubject = "CN=Collate Scripts Signing Certificate, O=Passeriform"

function Get-RegisteredCertificate([string]$Subject) {
  Write-Host "PATH 5"
  Write-Host (Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | ? { $_.Subject -match "$CertificateSubject" })
  return (Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | ? { $_.Subject -match "$CertificateSubject" })
}

function Register-Certificate([string]$CertificatePath) {
  Write-Host "PATH 6"
  Write-Host $CertificatePath
  Import-Certificate -FilePath $CertificatePath -CertStoreLocation Cert:\CurrentUser\Root
}

function Create-CollateCertificate() {
  $Params = @{
    Subject           = "$CertificateSubject"
    Type              = "CodeSigningCert"
    KeySpec           = "Signature"
    KeyUsage          = "DigitalSignature"
    FriendlyName      = "Collate scripts signing certificate"
    NotAfter          = [datetime]::now.AddYears(5)
    CertStoreLocation = 'Cert:\CurrentUser\My'
  }
  
  Write-Host "PATH 7"
  Write-Host $Params
  $CollateSigningCert = New-SelfSignedCertificate @Params

  Write-Host "PATH 8"
  Write-Host $CollateSigningCert

  return $CollateSigningCert
}

function Import-CollateCertificate($CertificateImportPath) {
  Write-Host "PATH 9"
  Write-Host $CertificateImportPath
  Import-Certificate -FilePath "$CertificateImportPath" -CertStoreLocation Cert:\CurrentUser\Root
}

function Export-CollateCertificate($CertificateExportPath, $CollateSigningCert) {
  Write-Host "PATH 10"
  Write-Host $CertificateExportPath
  Export-Certificate -FilePath "$CertificateExportPath" -Cert $CollateSigningCert
}

##### Getting certificate #####

function Get-CollateCertificate {
  <#
    If certificate file not found
      If certificate not in Cert:\CurrentUser\My
        Create certificate
      Export certificate to file
    Else
      If certificate not in Cert:\CurrentUser\My
          Import in Cert:\CurrentUser\My
    Import in Cert:\CurrentUser\Root
  #>
  $CollateCertificatePath = "$((Get-Item $PSCommandPath).Directory.FullName)\collate.cer"
  $CollateCertificate = Get-RegisteredCertificate $CertificateSubject
  
  Write-Host "PATH 11"

  Write-Host $CollateCertificatePath
  Write-Host $CollateCertificate

  Write-Host "PATH 12"

  Write-Host (!(Test-Path -Path $CollateCertificatePath -PathType Leaf))
  Write-Host (!$CollateCertificate)

  if (!(Test-Path -Path $CollateCertificatePath -PathType Leaf)) {
    Write-Host "PATH 1"
    if (!$CollateCertificate) {
      Write-Host "PATH 2"
      Create-CollateCertificate
    }
    
    Export-CollateCertificate $CollateCertificatePath $CollateSigningCert
  } else {
    Write-Host "PATH 3"
    if (!$CollateCertificate) {
      Write-Host "PATH 4"
      Import-CollateCertificate $CollateCertificatePath
    }
  }

  Register-Certificate "$CollateCertificatePath"

  # Fetch the latest certificate instance
  $CollateCertificate = Get-RegisteredCertificate "Collate Scripts Signing Certificate"

  Write-Host $CollateCertificate

  return $CollateCertificate
}

##### Signing scripts #####

function Sign-Script($ScriptPath, $Certificate) {
  Write-Host $ScriptPath
  Write-Host $Certificate
  Set-AuthenticodeSignature -Certificate $Certificate -FilePath $ScriptPath
}

#### Main ####

$CollateSigningCertificate = Get-CollateCertificate

$Scripts = Get-ChildItem -Path (Get-Item $PSCommandPath).Directory.Parent.GetDirectories("registry")

ForEach ($Script in $Scripts) {
  Sign-Script $Script.FullName $CollateSigningCertificate[0]
}

# SIG # Begin signature block
# MIIF6wYJKoZIhvcNAQcCoIIF3DCCBdgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4bYSu45vffJGdSxFp6/iHG9Z
# /nKgggNcMIIDWDCCAkCgAwIBAgIQbfydpuwJobRF5KiiFAzqSTANBgkqhkiG9w0B
# AQUFADBEMRQwEgYDVQQKDAtQYXNzZXJpZm9ybTEsMCoGA1UEAwwjQ29sbGF0ZSBT
# Y3JpcHRzIFNpZ25pbmcgQ2VydGlmaWNhdGUwHhcNMjIwMzMwMDkzMjQyWhcNMjcw
# MzMwMDk0MjMwWjBEMRQwEgYDVQQKDAtQYXNzZXJpZm9ybTEsMCoGA1UEAwwjQ29s
# bGF0ZSBTY3JpcHRzIFNpZ25pbmcgQ2VydGlmaWNhdGUwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQC+/S1lbJAfK0c4jnk4rF3pD+/L6WVHEStVghlXCeJQ
# pDLtmyPFpSs+VDkDA3wVQmAdlFp8nl40QluYvPQ+2FPQRWMrDHmdVQR5wGFlDaWx
# amxKSM/+M866u5cOzqm1ZUNt9pm7bFXfcPLZnBjK1fFoxK+vc3R4lgDtAWsaHSvT
# Bt8v5tzXMYliXRABlE9tKZikIqwxzo80kMDv2MUsuFIAidLHTamrlTN/CZQHmFRX
# TTTnBfk4FGxDOuWovZlTC6fMhIr5GHdNSNNaw7IQLhcBZe4m5g9Sbd+fFBCaThnF
# XicNhiqlRrAPwdg/fc/c+PjyaOXJ1fWBQ76TX/uTUZCtAgMBAAGjRjBEMA4GA1Ud
# DwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQU4HP5w00B
# BxVQ4yZE0yVtFWUA+cwwDQYJKoZIhvcNAQEFBQADggEBAHia9ZgfSEpJmGhBhzP3
# IPcj1aqArtcbUI80Uu/vHnVwyC1DfTFCZHbmv3VVXBrfeAR5DROqMxUqSxN9mzOV
# 0eID/B1sdju8f/HF5Vu3Bs06ErF4XhceW1Tq4H6AHbD3pvtpg/+tCunoo33u1TeI
# m0mjgKWJsB0y5ObIPjg0XvFHj/2AUG90zS1ZZzOFYKVxiyZt4UyZMynMGgoF0G+u
# QOKmnYccN6iDE236ZKvM3XL4w9jqyxaZDYhDZnVtrxVbKlUK0CEAxcUZjYHLN5+L
# 29Wzw/6KGzSlzyy8Veze4rC8IfmvpZ+/4lJBEUR7zLNKfs2rZeJ2lnH7IdDD+PjQ
# yQcxggH5MIIB9QIBATBYMEQxFDASBgNVBAoMC1Bhc3Nlcmlmb3JtMSwwKgYDVQQD
# DCNDb2xsYXRlIFNjcmlwdHMgU2lnbmluZyBDZXJ0aWZpY2F0ZQIQbfydpuwJobRF
# 5KiiFAzqSTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU2ElFAE72noo8egH8PshUe/+NqsQwDQYJ
# KoZIhvcNAQEBBQAEggEANX7YfXa9LRyRtWxBkA1MEUkasN5D7tFygP3K/Zkj1bmg
# TclW41K05ABNrVODnG3r/q78kQlRAhAZlbs+xtoe3IswvFz4TyjQUw2ZpRz9gSPr
# HGMpgRDT87d+VC4soBh1yR+dqww1PPWpPm+oxJT3hlLmBu3Hn7OBPj8zhh0Bzsm4
# tCpBR2YuqXAqKYUnd+oXfe/bL1m7dkLKBOlcFrhHWTky2Kfg11CCQJpJb++/UxMq
# LP4RaCpEttDAzmpJqIFJCH3YxUjTKdgEL5VDnmUlLCW3HKxmhrV5Auz1EotLPzin
# 0PwCsToJ8FDBQmNc74HFdmM+v7BcmxCQJNlRRLDXgw==
# SIG # End signature block
