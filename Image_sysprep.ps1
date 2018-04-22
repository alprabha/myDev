Stop-AzureRmVM -ResourceGroupName iharg -Name ihavm1
Set-AzureRmVm -ResourceGroupName iharg -Name ihavm1 -Generalized
$vm = Get-AzureRmVM -ResourceGroupName iharg -Name ihavm1 -status
$vm.Statuses
##Save-AzureRmVMImage -ResourceGroupName iharg -Name ihavm1 -DestinationContainerName YourImagesContainer -VHDNamePrefix YourTemplatePrefix -Path i:\Filename.json

Save-AzureRmVMImage -ResourceGroupName iharg -Name ihavm1 -DestinationContainerName "windowsvmtemplate" -VHDNamePrefix "image" -Path "I:\CaptTemplate.json"

$imageURI = "https://ihavm1.blob.core.windows.net/system/Microsoft.Compute/Images/windowsvmtemplate/image-osDisk.76560db8-9342-4fa1-9b2e-0b77b851a3cc.vhd"

##create new VM

$ipName = ""
$pip = New-AzureRmPublicIpAddress -Name pip -ResourceGroupName iharg -Location 'North Europe' -AllocationMethod Dynamic
$nicName = "<nicName>"
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName iharg -Name ihavnet
$nic = New-AzureRmNetworkInterface -Name nic -ResourceGroupName iharg -Location 'North Europe' -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id

$cred = Get-Credential

#Create variables
# Enter a new user name and password to use as the local administrator account for the remotely accessing the VM
$cred = Get-Credential

# Name of the storage account 
$storageAccName = "<storageAccountName>"

# Name of the virtual machine
$vmName = "<vmName>"

# Size of the virtual machine. See the VM sizes documentation for more information: https://azure.microsoft.com/documentation/articles/virtual-machines-windows-sizes/
$vmSize = "<vmSize>"

# Computer name for the VM
$computerName = "<computerName>"

# Name of the disk that holds the OS
$osDiskName = "<osDiskName>"

# Assign a SKU name
# Valid values for -SkuName are: **Standard_LRS** - locally redundant storage, **Standard_ZRS** - zone redundant storage, **Standard_GRS** - geo redundant storage, **Standard_RAGRS** - read access geo redundant storage, **Premium_LRS** - premium locally redundant storage. 
$skuName = "<skuName>"

# Create a new storage account for the VM
New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $storageAccName -Location $location -SkuName $skuName -Kind "Storage"

#Get the storage account where the uploaded image is stored
$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -AccountName $storageAccName

#Set the VM name and size
#Use "Get-Help New-AzureRmVMConfig" to know the available options for -VMsize
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize

#Set the Windows operating system configuration and add the NIC
$vm = Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows -ComputerName $computerName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate

$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id

#Create the OS disk URI
$osDiskUri = '{0}vhds/{1}-{2}.vhd' -f $storageAcc.PrimaryEndpoints.Blob.ToString(), $vmName.ToLower(), $osDiskName

#Configure the OS disk to be created from the image (-CreateOption fromImage), and give the URL of the uploaded image VHD for the -SourceImageUri parameter
#You set this variable when you uploaded the VHD
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption fromImage -SourceImageUri $imageURI -Windows

#Create the new VM
New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm
