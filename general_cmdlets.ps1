Select-AzureRmProfile -Path I:\alwincgcrednew2
save-AzureRmProfile -Path I:\alwincgcrednew2

Select-AzureRmSubscription -SubscriptionId "d4005541-5154-4f35-8704-1cffe6730754"

Get-AzureRmVMUsage -Location "north europe"

Get-AzureRmVMSize -Location "southeast asia"
Get-AzurermResource  | Export-CSV Allresources.CSV
$rgname= 'CTBSP2010'
Find-AzureRmResource -ResourceGroupName $ResourceGroupName | Export-CSV UAT.CSV

Find-AzureRmResource -ResourceGroupName $ResourceGroupName | Export-CSV Staging.CSV

Find-AzureRmResource -ResourceGroupName $ResourceGroupName | Export-CSV Prod_DMZ.CSV

Find-AzureRmResource -ResourceGroupName $ResourceGroupName | Export-CSV Prod.CSV

Find-AzureRmResource -ResourceGroupName $ResourceGroupName | Export-CSV Securitydata.CSV

Get-AzureRmResource | Group-Object ResourceType| Export-CSV UAT.CSV

Get-AzureRmResource -ResourceType Microsoft.Web/serverFarms

Get-AzureRmResource -Name ContosoLabWeb -ResourceGroupName ContosoLabsRG -ResourceType "Microsoft.Web/sites" -ApiVersion 2014-04-01


$vmList = Get-AzureRmVM -ResourceGroupName iharg


$vmList.Name

$vmList = Get-AzureRmVM -ResourceGroupName $rgName -Name ihavm1


Start-AzureRmVM -ResourceGroupName $rgName -Name $vmName
Restart-AzureRmVM -ResourceGroupName $rgName -Name $vmName
Remove-AzureRmVM -ResourceGroupName $rgName –Name $vmName

https://azure.microsoft.com/en-in/documentation/articles/virtual-machines-windows-ps-manage/



Get-AzureRmNetworkInterface -Name rds699 -ResourceGroupName ihamgmt | Get-AzureRmNetworkInterfaceIpConfig | select-object  PrivateIpAddress,PrivateIpAllocationMethod

Get-AzureRmPublicIpAddress -Name $publicIpName -ResourceGroupName $rgName
Get-AzureRmPublicIpAddress >> i:\IPs.txt
Get-AzureRmPublicIpAddress | select-object  name,IpAddress,PublicIpAllocationMethod >> i:\IPs.txt



Get-AzureRmPublicIpAddress | select-object  name,IpAddress,PublicIpAllocationMethod | Export-CSV AllPIPs.CSV

Get-AzureRmNetworkInterface | Get-AzureRmNetworkInterfaceIpConfig | select-object  PrivateIpAddress,PrivateIpAllocationMethod  | Export-CSV AllIPs.CSV

Get-AzureRmNetworkInterface | select-object  name,resourcegroupname | Export-CSV Allnics.CSV
$conf= Get-AzureRmNetworkInterface | select-object  name,resourcegroupname
$conf.IpConfigurations.PrivateIpAddress
Get-AzureRMResource | Export-CSV AllAzureRes.CSV

Get-AzureRmVirtualNetwork | select-object  name,resourcegroupname  | Export-CSV Alladdressspaces.CSV

Get-AzureRmVirtualNetwork | Get-AzureRmVirtualNetworkSubnetConfig | select-object  name,addressprefix | Export-CSV Alladdressspaces7.CSV


Get-AzureRmVM -ResourceGroupName $rgName

Get-AzureRmVM -ResourceGroupName $rgName -name CTBSTGSQL -Status

$VMs = Get-AzureRmVM -ResourceGroupName $rgName


AzureRmRoleAssignment

Get-AzureRmRoleAssignment -SignInName  Alwin.prabhakar_capgemini.com#EXT#@iweof.onmicrosoft.com | FL DisplayName, RoleDefinitionName, Scope

Get-AzureRmRoleAssignment -SignInName Alwin.prabhakar_capgemini.com#EXT#@iweof.onmicrosoft.com -ExpandPrincipalGroups | FL DisplayName, RoleDefinitionName, Scope
Get-AzureRmRoleDefinition | ? {$_.IsCustom -eq $true} | FT Name, IsCustom 

Get-AzureRmRoleDefinition | FT Name, Description  > test.txt

Get-AzureRmRoleDefinition owner | FL Actions, NotActions

(Get-AzureRmRoleDefinition "owner").Actions

Get-AzureRmVM |ft osprofile.computername, storageprofile.imagereference.publisher, storageprofile.imagereference.offer, storageprofile.imagereference.sku  | Export-CSV AllIPs.CSV
$VMs.osprofile.computername,$VMs.storageprofile.imagereference.publisher,$VMs.storageprofile.imagereference.offer,$vms.storageprofile.imagereference.sku >> windows_ver.txt


# Show the Network interfaces (PRIMAR STATUS ALSO )
$VM = Get-AzureRmVM -ResourceGroupName lbtest -Name myvm0
$VM.NetworkProfile.NetworkInterfaces

$nic = Get-AzureRmNetworkInterface -ResourceGroupName lbtest -Name nic0
$nicp = Get-AzureRmNetworkInterface -ResourceGroupName Prod_Toolbox_rg  -Name WEBSRV1_Prod_vNic1

$nic
$loadbalancer = Get-AzureRmLoadBalancer -Name "myLB" -ResourceGroupName "lbtest" > test.txt
$loadbalancerp = Get-AzureRmLoadBalancer -Name "ctbalb" -ResourceGroupName "Prod_Toolbox_rg" > test1.txt

$loadbalancer > test.txt
$loadbalancerp > test1.txt

$bepool =get-AzureRmLoadBalancerBackendAddressPoolConfig  -name backendpool1 -LoadBalancer myLB

$bepool=Get-AzureRmLoadBalancerBackendAddressPoolConfig -Name "backendpool1"  -LoadBalancer $loadbalancer

New-AzureRmRoleAssignment -SignInName  finn.nyman@ikea.com -RoleDefinitionName contributor 
Get-AzureRmRoleAssignment -SignInName  finn.nyman@ikea.com | FL DisplayName, RoleDefinitionName, Scope 


##rempve NIC NAT Deletion


$nic = Get-AzureRmNetworkInterface -ResourceGroupName 'DMZ_Toolbox_RG' -Name 'NATSRV1_DMZ_vNic2'
Remove-AzureRmNetworkInterface -ResourceGroupName 'DMZ_Toolbox_RG' -Name $nic.Name -Force


$pip = Get-AzureRmPublicIpAddress -Name 'NATSRV_DMZ_Pip' -ResourceGroupName 'DMZ_Toolbox_RG'
  Remove-AzureRmPublicIpAddress -Name 'NATSRV_DMZ_Pip' -ResourceGroupName 'DMZ_Toolbox_RG'

  remove-AzureRmAvailabilitySet -Name 'DMZ_NAT_AVset' -ResourceGroupName 'DMZ_Toolbox_RG'
  DMZ_NAT_AVset

 remove-AzureRmNetworkSecurityGroup -Name  'DMZ_NAT_NSG' -ResourceGroupName dmz_toolbox_rg 





