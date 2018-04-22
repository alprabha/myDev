#With UNMANAGED DISK
Param
(
[Parameter(Mandatory=$True)]
[String]
$VnetadressPrefix
)

$ResourceGroupName = 'rg5'
$VnetName = 'corpvnet'
$InterfaceName = 'nics'
$StorageAcName = 'webfarmsnewt11'
$StorageType = 'Standard_LRS'
$WindowsImage = '2012-R2-Datacenter' 
$VMInstanceSize = 'Standard_B1s'
$Subnetname = 'WEB'
$ResourceGroupLocation = 'southeast asia'
$VnetadressPrefix = '10.0.0.0/24'
$SubNet1Prefix = '10.0.0.0/28'

Login-AzureRmAccount 

new-azurermresourcegroup -name $ResourceGroupName -location $ResourceGroupLocation      
           

   
$credvm = Get-Credential


#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if(!$resourceGroupLocation) {
        $resourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************





##$vnet = Get-AzureRmVirtualNetwork -Name NRPVNet -ResourceGroupName NRP-RG
##$backendSubnet = Get-AzureRmVirtualNetworkSubnetConfig -Name LB-Subnet-BE -VirtualNetwork $vnet



$subnet1 = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnetname -AddressPrefix $SubNet1Prefix

#$subnet2 = New-AzureRmVirtualNetworkSubnetConfig -Name 'Backend' -AddressPrefix $SubNet2Prefix



#New-AzureRmVirtualNetwork -Name $Vnetname -ResourceGroupName $ResourceGroupName -Location $resourceGroupLocation -AddressPrefix $VnetadressPrefix -Subnet $subnet1, $subnet2

New-AzureRmVirtualNetwork -Name $Vnetname -ResourceGroupName $ResourceGroupName -Location $resourceGroupLocation -AddressPrefix $VnetadressPrefix -Subnet $subnet1


#******************************************************************************
# VNet deployment Execution Ends here
#******************************************************************************

#******************************************************************************
# NSG Creation starts here
#******************************************************************************
 

$rule1 = New-AzureRmNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389

$rule2 = New-AzureRmNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 80

$rule3 = New-AzureRmNetworkSecurityRuleConfig -Name ssl-rule -Description "Allow HTTPS" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 102 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 443

<#new rule    
$rule10 = New-AzureRmNetworkSecurityRuleConfig -Name Backend-sqlrule -Description "Allow BE subnet" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
    -SourceAddressPrefix '10.10.10.16/28' -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 1433  #>

$nsgfront = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -Name "NSG-FrontEnd" -SecurityRules $rule1,$rule2,$rule3 

    $nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -Name "NSG-FrontEnd" -SecurityRules $rule1

<#add rule to existing NSG#>
#Get-AzureRmNetworkSecurityGroup -Name  'NSG-FrontEnd' -ResourceGroupName 'CTBSTG2013'| Add-AzureRmNetworkSecurityRuleConfig -Name Backend-sqlrule -Description "Allow BE subnet" -Access Allow -Protocol Tcp -Direction Inbound -Priority 105 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 1433 | Set-AzureRmNetworkSecurityGroup







#$nsgback = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -Name "NSG-BackEnd" -SecurityRules $rule4,$rule5,$rule6

    $vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -Name $VnetName

Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetname -AddressPrefix $SubNet1Prefix -NetworkSecurityGroup $nsgfront

$vnet | Set-AzureRmVirtualNetwork 

        
           
$Windowsimage = 
           (Get-AzureRmVMImageSku  -Location $resourceGroupLocation -PublisherName MicrosoftWindowsServer -Offer WindowsServer | Out-GridView `
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

  $availset = New-AzureRmAvailabilitySet -ResourceGroupName $ResourceGroupName -Name "avset" -Location $resourceGroupLocation
  #$availset = get-AzureRmAvailabilitySet $rgName -name DMZ_RDS_AVset

    
   ## $vmconfig=New-AzureRmVMConfig -VMName $vmName -VMSize $vminstanceSize
     $vmconfig=New-AzureRmVMConfig -VMName $vmName -VMSize $vminstanceSize -AvailabilitySetID $availset.Id

    $vm=Set-AzureRmVMOperatingSystem -VM $vmconfig -Windows -ComputerName $vmName -Credential $credvm -ProvisionVMAgent -EnableAutoUpdate
    
    $vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer  -Skus $WindowsImage -Version "latest"

     

    $OSDiskName = $vmName + "osDisk"
        # Storage
    $StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAcName -Type $StorageType -Location $ResourceGroupLocation
    ## Setup local VM object
 #$Publisher = Get-AzureRmVMImagePublisher -Location $resourceGroupLocation | where PublisherName -EQ MicrosoftWindowsServer
        
        #$Offer = Get-AzureRmVMImageOffer -Location $resourceGroupLocation -PublisherName $Publisher.PublisherName
        
       # $MySKU = Get-AzureRmVMImageSku  -Location $resourceGroupLocation -PublisherName $Publisher.PublisherName -Offer $Offer.Offer | Where Skus -EQ $WindowsImage | Foreach Skus


   $PIp = 'vmpip'
    $PIp = New-AzureRmPublicIpAddress -Name $PIp -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -AllocationMethod Dynamic
    
     $vnet = Get-AzureRmVirtualNetwork -Name $vnetname -ResourceGroupName $ResourceGroupName
      $Subnet1 = Get-AzureRmVirtualNetworkSubnetConfig -Name  $subnetname -VirtualNetwork $Vnet
   
   # $SubnetS = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet | Out-GridView
    
    $nic = 'vm_vNic1'
    
   # $Interface = New-AzureRmNetworkInterface -Name $nic -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -SubnetId $SubnetS -PublicIpAddressId $PIp.Id -PrivateIpAddress '10.1.10.16'
  $Interface = New-AzureRmNetworkInterface -Name $nic -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -SubnetId $Subnet1.id -PublicIpAddressId $PIp.Id 
  
   $VirtualMachine = Add-AzureRmVMNetworkInterface -VM $vm -Id $Interface.Id
    $OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
    $VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage

  
    ## Create the VM in Azure
    New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -VM $VirtualMachine
    
