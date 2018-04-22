#Add Data Disks - Suggest only adding same caching type at once and setup in Windows to avoid confusion 

#Specify your VM Name 
$vmName="CTBPRODAPPSRV2" 
#Specify your Resource Group 
$rgName = "prod_Toolbox_RG" 
#Specify your Storage account name
$saName="prodstgwebappdbnode2"
#This pulls your storage account info for use later 
$storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $saName 
#Pulls the VM info for later 
$vmdiskadd=Get-AzurermVM -ResourceGroupName $rgname -Name $vmname 
#Sets the URL string for where to store your vhd files - converts to https://azmonkeyplrs.blob.core.windows.net/vhds
#Also adds the VM name to the beginning of the file name 
$DataDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $vmName 
Add-AzureRmVMDataDisk -CreateOption empty -DiskSizeInGB 150 -Name $vmname-Data01 -VhdUri $DataDiskUri-Data.vhd -VM $vmdiskadd -Caching ReadOnly -lun 0 
Add-AzureRmVMDataDisk -CreateOption empty -DiskSizeInGB 1023 -Name $vmName-Data02 -VhdUri $DataDiskUri-Data02.vhd -VM $vmdiskadd -Caching ReadOnly -lun 1 
Add-AzureRmVMDataDisk -CreateOption empty -DiskSizeInGB 1023 -Name $vmName-Data03 -VhdUri $DataDiskUri-Data03.vhd -VM $vmdiskadd -Caching None -lun 2 
Add-AzureRmVMDataDisk -CreateOption empty -DiskSizeInGB 1023 -Name $vmName-Data04 -VhdUri $DataDiskUri-Data04.vhd -VM $vmdiskadd -Caching ReadWrite -lun 3 
#Updates the VM with the disk config - does not require a reboot 
Update-AzureRmVM -ResourceGroupName $rgname -VM $vmdiskadd


##OS disk example  $OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
 ##   $VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage