
$ResourceGroupName = 'jasonvm'
$VnetName = 'MYvNET'
$InterfaceName = 'nics'
$WindowsImage = '2012-R2-Datacenter' 
$VMInstanceSize = 'Standard_B1s'
$vmname = 'alivm'
$Subnetname = 'WEB'
$ResourceGroupLocation = 'southeast asia'
$VnetadressPrefix = '10.0.0.0/24'
$SubNet1Prefix = '10.0.0.0/28'
$Diskname = 'myVM_OsDisk_1_0726d64a49684f11890a6e4211871285'
$location = 'east us'





#Get the Managed Disk based on the resource group and the disk name
$disk =  Get-AzureRmDisk -ResourceGroupName $resourceGroupName -DiskName $diskName

#Initialize virtual machine configuration
$VirtualMachine = New-AzureRmVMConfig -VMName $vmname -VMSize $VMInstanceSize

#Use the Managed Disk Resource Id to attach it to the virtual machine. Please change the OS type to linux if OS disk has linux OS
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -CreateOption Attach -Windows

#Create a public IP for the VM  
$publicIp = New-AzureRmPublicIpAddress -Name ($vmname.ToLower()+'_ip') -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic

#Get the virtual network where virtual machine will be hosted
$vnet = Get-AzureRmVirtualNetwork -Name $vnetname -ResourceGroupName $resourceGroupName

# Create NIC in the first subnet of the virtual network 
$nic = New-AzureRmNetworkInterface -Name ($vmname.ToLower()+'_nic') -ResourceGroupName $resourceGroupName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

#Create the virtual machine with Managed Disk
New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName -Location $location

