function Convert-SecureStringToPlainText {
    param (
        [System.Security.SecureString]$SecureString,
        [string]$KeyFilePath
    )
    
    # Read the key from the key file
    $Key = Get-Content -Path $KeyFilePath -Raw

    # Convert the key from string to a byte array
    $KeyBytes = [Convert]::FromBase64String($Key)

    # Decrypt the SecureString using the key
    $Pointer = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    
    try {
        # Convert SecureString to plain text
        $PlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($Pointer)
        return $PlainText
    }
    finally {
        # Zero out the BSTR memory
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Pointer)
    }
}

# Usage example:
# Assuming you have a SecureString in a variable $secureString and a key file located at "C:\path\to\keyfile.key"
$plainText = Convert-SecureStringToPlainText -SecureString $secureString -KeyFilePath "C:\path\to\keyfile.key"
Write-Host "Plain Text: $plainText"
