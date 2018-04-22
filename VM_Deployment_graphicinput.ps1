

Param
(
      
 
 [Parameter(Mandatory=$True)]
 [string]
 $ResourceGroupLocation,

  [Parameter(Mandatory=$True)]
 [string]
 $StorageType,

 [Parameter(Mandatory=$True)]
 [string]
 $NumberOfVM,

 [Parameter(Mandatory=$True)]
 [string]
 $vmName,

 

 [String]$TimeZone = [System.TimeZoneInfo]::Local.Id
        
) 


Login-AzureRmAccount
                
#$ResourceGroupName = 'corprg'
#$ResourceGroupLocation = East US
#$VnetName = 'corpvnet'
#$InterfaceName = 'nics'
#$StorageAcName = 'webnewstorage'
#$StorageType = 'Standard_LRS'
#$WindowsImage = '2012-R2-Datacenter'
#$VMInstanceSize = 'Standard_A2'
#$NumberOfVM = '1'
#$Subnetname = 'WEB'



#$NumberOfVMs = $NumberOfVM
##$ResourceGroupName = $ResourceGroup
#$Location = $ResourceGroupLocation

## Storage
##$StorageNamenew = $StorageName
##$StorageTypes = $StorageType




## Network
##$InterfaceName = "<your interface name>"
##$Subnet1Name = "Subnet1"
##$VNetName = "<your vnet name>"
##$VNetAddressPrefix = "10.0.0.0/16"
##$VNetSubnetAddressPrefix = "10.0.0.0/24"

## Compute
#$vmSize = "Standard_A2"

$ResourceGroupName =
            
           ( Get-AzureRmResourceGroup | Out-GridView `
                  -Title "Select an Azure Resource Group ..." `
                  -PassThru
           ).ResourceGroupName

$VnetName =
           (Get-AzureRmVirtualNetwork -resourcegroupname $ResourceGroupName | Select Name | Out-GridView `
                 -Title "Select an Azure vNet ..." `
                 -PassThru
           ).Name

$vnet = Get-AzureRmVirtualNetwork -Name $vnetname -ResourceGroupName $ResourceGroupName

$SubnetS = (Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet | select name,ID | Out-GridView  `
                -Title "Select an Azure subnet ..." `
                -PassThru
           ).ID

$VMInstanceSize =         
           ( Get-AzureRoleSize | Out-GridView `
                  -Title "Select an Azure Instance Size ..." `
                  -PassThru
           ).instanceSize

$Windowsimage = 
           (Get-AzureRmVMImageSku  -Location 'east us2' -PublisherName MicrosoftWindowsServer -Offer WindowsServer | Out-GridView `
                  -Title "Select an Azure skus ..." `
                  -PassThru
           ).skus
   
$credvm = Get-Credential

<#if($VMInstanceSize = 'small')
 { 
   $VMInstanceSize = 'Standard_A0';
 }
 else 
 {      
   $VMInstanceSize = $VMInstanceSize ;
 }
  
   ($VMInstanceSize ='medium')
  $VMInstanceSize = 'Standard_A1';
 }
 #>
$i = 1;

Do 
{ 
    $i; 
    $vmName=$vmName+$i
    $vmconfig=New-AzureRmVMConfig -VMName $vmName -VMSize $vminstanceSize

    $vm=Set-AzureRmVMOperatingSystem -VM $vmconfig -Windows -ComputerName $vmName -Credential $credvm -ProvisionVMAgent -EnableAutoUpdate

     

    $OSDiskName = $vmName + "osDisk"
    # Storage
    $StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $vmName -Type $StorageType -Location $ResourceGroupLocation
    ## Setup local VM object
 #$Publisher = Get-AzureRmVMImagePublisher -Location $resourceGroupLocation | where PublisherName -EQ MicrosoftWindowsServer
        
        #$Offer = Get-AzureRmVMImageOffer -Location $resourceGroupLocation -PublisherName $Publisher.PublisherName
        
       # $MySKU = Get-AzureRmVMImageSku  -Location $resourceGroupLocation -PublisherName $Publisher.PublisherName -Offer $Offer.Offer | Where Skus -EQ $WindowsImage | Foreach Skus


    $vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer  -Skus $WindowsImage -Version "latest"
    $PIp = $vmName + 'pip'
    $PIp = New-AzureRmPublicIpAddress -Name $PIp -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -AllocationMethod Dynamic
    
     $vnet = Get-AzureRmVirtualNetwork -Name $vnetname -ResourceGroupName $ResourceGroupName
   
   # $SubnetS = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet | Out-GridView
    
    $nic = $vmName+'nic'
    
    $Interface = New-AzureRmNetworkInterface -Name $NIC -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -SubnetId $SubnetS -PublicIpAddressId $PIp.Id
   
    $VirtualMachine = Add-AzureRmVMNetworkInterface -VM $vm -Id $Interface.Id
    $OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
    $VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage 

    ## Create the VM in Azure
    New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -VM $VirtualMachine
    $i +=1
} 
Until ($i -gt $NumberOfVM)