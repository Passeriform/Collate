##### Internal methods ####

$CertificateSubject = "CN=Collate Scripts Signing Certificate, O=Passeriform"

function Get-RegisteredCertificate([string]$Subject) {
  return (Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | ? { $_.Subject -match "$CertificateSubject" })
}

function Register-Certificate([string]$CertificatePath) {
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

  $CollateSigningCert = New-SelfSignedCertificate @Params

  return $CollateSigningCert
}

function Import-CollateCertificate($CertificateImportPath) {
  Import-Certificate -FilePath "$CertificateImportPath" -CertStoreLocation Cert:\CurrentUser\Root
}

function Export-CollateCertificate($CertificateExportPath, $CollateSigningCert) {
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

  if (!(Test-Path -Path $CollateCertificatePath -PathType Leaf)) {
    if (!$CollateCertificate) {
      Create-CollateCertificate
    }

    Export-CollateCertificate $CollateCertificatePath $CollateSigningCert
  } else {
    if (!$CollateCertificate) {
      Import-CollateCertificate $CollateCertificatePath
    }
  }

  Register-Certificate "$CollateCertificatePath"

  # Fetch the latest certificate instance
  $CollateCertificate = Get-RegisteredCertificate "Collate Scripts Signing Certificate"

  return $CollateCertificate
}

##### Signing scripts #####

function Sign-Script($ScriptPath, $Certificate) {
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfTspyS2yYqG3NkwZEPjxdcTE
# PmSgggNcMIIDWDCCAkCgAwIBAgIQNJXPexLXZr1OqwRQr/pPkzANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUI2650vn5wAZ8sSfOgETIsClexDQwDQYJ
# KoZIhvcNAQEBBQAEggEAgMBaVDF+FcKdHCHa8N6q8K2NCj8YPzrlJjhswm822eVA
# krBlN0oxalFE+r3Rju8tNMnExkUAd2VIlUdier/5QzPb6mzpNnhv56nGxo6/5Hmc
# aMlSvQnVc99n95hVPi3lOQv3kaNGkqTNw4o23CIcyNzcrspvsWKE3GP192dv71ZW
# luk9BQDQs6bRsWv6BjGJZ4nlzCp0kI1RYjMEMSDnQAnIhznaUrgvuLSN2na6D1Kx
# 5xIoke7p/HvaX4OAz4QUcnMJ5H2p9KfnSl2TvkuQvUc5uKMobMfaFzUgwRK1IW8m
# bo2rBr/jSY1BbGpcjk5KwRKllWhXVQKKMhREKlsPaQ==
# SIG # End signature block
