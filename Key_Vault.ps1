
New-AzureRmKeyVault -VaultName 'ihakeyvault' -ResourceGroupName 'rg5' -Location 'southeastasia'

$key = Add-AzureKeyVaultKey -VaultName 'ihakeyvault' -Name 'KEK' -Destination 'Software'


##To display the URI for this key, type:
get-AzureKeyVaultKey -VaultName 'ihakeyvault' -Name 'KEK'

$secretvalue = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
$secret = Set-AzureKeyVaultSecret -VaultName 'ihakeyvault' -Name 'BLPassword' -SecretValue $secretvalue

$Key.key.kid


##Key Vault APP


  $SecureStringPassword = ConvertTo-SecureString -String "password" -AsPlainText -Force
  $app = New-AzureRmADApplication -DisplayName "ihakey" -HomePage "https://ihakey" -IdentifierUris "https://ihakey" -Password $SecureStringPassword
 

 New-AzureRmADServicePrincipal -ApplicationId $app.ApplicationId
 New-AzureRmRoleAssignment -RoleDefinitionName Reader -ServicePrincipalName $app.ApplicationId.Guid



 $KeyVault = Get-AzureRmKeyVault -VaultName ihakeyvault -ResourceGroupName rg5;
 $diskEncryptionKeyVaultUrl = $KeyVault.VaultUri
 $KeyVaultResourceId = $KeyVault.ResourceId
 $aadClientID = '2d30f8f8-76c1-45ff-a833-b980ed559bad'
 $aadClientSecret= 'xnKgscIXE+VuTUovtbvj3CkPIjWBFO9pEScqEazd4Lw='

 Set-AzureRmKeyVaultAccessPolicy -VaultName ihakeyvault -ServicePrincipalName $aadClientID -PermissionsToKeys all -PermissionsToSecrets all -ResourceGroupName rg5
 Set-AzureRmKeyVaultAccessPolicy -VaultName ihakeyvault -ResourceGroupName rg5 –EnabledForDiskEncryption
 Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName rg5 -VMName alivm1 -AadClientID $aadClientID -AadClientSecret $aadClientSecret -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $KeyVaultResourceId;

 ##Status
 Get-AzureRmVmDiskEncryptionStatus  -ResourceGroupName rg5 -VMName alivm1
 ##Get a list of all disk encryption secrets used for encrypting VM in your subscription
 Get-AzureKeyVaultSecret -VaultName ihakeyvault | where {$_.Tags.ContainsKey(‘DiskEncryptionKeyFileName’)} | format-table @{Label=”MachineName”; Expression={$_.Tags[‘MachineName’]}}, @{Label=”VolumeLetter”; Expression={$_.Tags[‘VolumeLetter’]}}, @{Label=”EncryptionKeyURL”; Expression={$_.Id}}
 
Get-AzureKeyVaultKey –VaultName 'ihakeyvault'

 ##    https://blogs.msdn.microsoft.com/azuresecurity/2015/11/16/explore-azure-disk-encryption-with-azure-powershell/