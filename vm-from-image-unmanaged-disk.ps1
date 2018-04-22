
$ResourceGroupName = 'rg5'
$VnetName = 'corpvnet'
$InterfaceName = 'nics'
$WindowsImage = '2012-R2-Datacenter' 
$VMInstanceSize = 'Standard_B1s'
$vmname = 'alivm33'



$disknameOS = 'os-disk'
$location = 'southeastasia'





#Get the Managed Disk based on the resource group and the disk name

#$vhduri = "https://webfarmsnewt11.blob.core.windows.net/vhds/ZCosDisk.vhd"
 $VirtualMachine = New-AzureRmVMConfig -VMName "VirtualMachine35" -VMSize "Standard_A1" 
     #Set-AzureRmVMOSDisk -VM $VirtualMachine -Name "OsDisk12" -VhdUri "os.vhd" -Caching ReadWrite
     $VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName "MainComputer" -Credential (Get-Credential) 
    $VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest" 
    $VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name "osDisk.vhd" -VhdUri "https://webfarmsnewt11.blob.core.windows.net/vhds/osDisk.vhd" -CreateOption FromImage
     




#Initialize virtual machine configuration
#$VirtualMachine = New-AzureRmVMConfig -VMName $vmname -VMSize $VMInstanceSize

#Use the Managed Disk Resource Id to attach it to the virtual machine. Please change the OS type to linux if OS disk has linux OS
#$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $disknameOS -VhdUri $vhduri -CreateOption Attach -Windows -Caching ReadWrite

#Create a public IP for the VM  
$publicIp = New-AzureRmPublicIpAddress -Name ($vmname.ToLower()+'_ip') -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic

#Get the virtual network where virtual machine will be hosted
$vnet = Get-AzureRmVirtualNetwork -Name $vnetname -ResourceGroupName $resourceGroupName

# Create NIC in the first subnet of the virtual network 
$nic = New-AzureRmNetworkInterface -Name ($vmname.ToLower()+'_nic') -ResourceGroupName $resourceGroupName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

#Create the virtual machine with Managed Disk
New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName -Location 'southeastasia'


