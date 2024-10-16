function Convert-SecureStringToPlainText {
    param (
        [System.Security.SecureString]$SecureString,
        [string]$KeyFilePath
    )
    
    # Read the key from the key file (optional if not using encryption)
    $Key = Get-Content -Path $KeyFilePath -Raw

    # Convert the SecureString to plain text
    $Pointer = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    
    try {
        # Convert the BSTR pointer to a regular string
        $PlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($Pointer)
        return $PlainText
    }
    finally {
        # Zero out the BSTR memory to avoid memory leaks
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Pointer)
    }
}

# Example usage
# Create a SecureString for demonstration (this should be your existing SecureString)
$secureString = ConvertTo-SecureString "YourSecretPassword" -AsPlainText -Force

# Path to your key file (if necessary)
$keyFilePath = "C:\path\to\your\keyfile.key"

# Convert the SecureString to plain text
$plainText = Convert-SecureStringToPlainText -SecureString $secureString -KeyFilePath $keyFilePath
Write-Host "Plain Text: $plainText"
