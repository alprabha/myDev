Stop-AzureRmVM -ResourceGroupName $rgName -Name $vmname


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
 $vmName

          
) 

$ResourceGroupLocation = 'North Europe'

#Login-AzureRmAccount
                
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

$VMInstanceSize = 'Standard_D3' 
<#
$PublisherName = "MicrosoftSQLServer"
$OfferName = "SQL2014SP1-WS2012R2"
$Sku = "Evaluation"
$Version = "latest"
 #>       
           
$Windowsimage = 
           (Get-AzureRmVMImageSku  -Location 'North Europe' -PublisherName MicrosoftSQLServer -Offer SQL2014SP1-WS2012R2 | Out-GridView `
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

    $availset = get-AzureRmAvailabilitySet -ResourceGroupName $ResourceGroupName -Name "Prod_DB_Aset" -Location "North Europe"

    $vmconfig=New-AzureRmVMConfig -VMName $vmName -VMSize $vminstanceSize -AvailabilitySetID $availset.Id
    

    $vm=Set-AzureRmVMOperatingSystem -VM $vmconfig -Windows -ComputerName $vmName -Credential $credvm -ProvisionVMAgent -EnableAutoUpdate

     

    $OSDiskName = $vmName + "osDisk"
        # Storage
    $StorageAccount = get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name prodstgwebappdbnode2 -Type 'Standard_LRS' -Location 'North Europe'

    New-AzureRmStorageAccount -ResourceGroupName 'DMZ_Toolbox_RG' -Name dmzstgadrdsnodes1 -Type 'Standard_LRS' -Location 'North Europe'

    ## Setup local VM object
 #$Publisher = Get-AzureRmVMImagePublisher -Location $resourceGroupLocation | where PublisherName -EQ MicrosoftWindowsServer
        
        #$Offer = Get-AzureRmVMImageOffer -Location $resourceGroupLocation -PublisherName $Publisher.PublisherName
        
       # $MySKU = Get-AzureRmVMImageSku  -Location $resourceGroupLocation -PublisherName $Publisher.PublisherName -Offer $Offer.Offer | Where Skus -EQ $WindowsImage | Foreach Skus


    $vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName MicrosoftSQLServer -Offer SQL2014SP1-WS2012R2  -Skus $WindowsImage -Version "latest"
   $PIp =$vmName + 'pip'
    $PIp = New-AzureRmPublicIpAddress -Name ctbstgadpip -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -AllocationMethod Dynamic
    
     $vnet = Get-AzureRmVirtualNetwork -Name $vnetname -ResourceGroupName $ResourceGroupName
   
   # $SubnetS = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet | Out-GridView
    
    $Interface1 = new-AzureRmNetworkInterface -Name 'DBWitness_vNic1' -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -SubnetId $SubnetS -PrivateIpAddress '10.20.50.5'
    $Interface2 = new-AzureRmNetworkInterface -Name 'DBWitness_mgmt_vNic1' -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -SubnetId $SubnetS -PrivateIpAddress '10.20.50.30'
    
   $VirtualMachine = remove-AzureRmVMNetworkInterface -VM $vm -Id $Interface1.Id -Primary
   $VirtualMachine = remove-AzureRmVMNetworkInterface -VM $vm -Id $Interface2.Id 
   
    ##$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $vm -Id $Interface.Id

    $OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
    $VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage 

    ## Create the VM in Azure
    New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location 'North Europe' -VM $VirtualMachine
    
