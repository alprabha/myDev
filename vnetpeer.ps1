Register-AzureRmProviderFeature -FeatureName AllowVnetPeering -ProviderNamespace Microsoft.Network

Register-AzureRmResourceProvider -ProviderNamespace Microsoft.Network
$vnet1 = Get-AzureRmVirtualNetwork -ResourceGroupName 'dmz_toolbox_rg' -Name 'DMZ_Toolbox_vNet'
$vnet2 = Get-AzureRmVirtualNetwork -ResourceGroupName 'Prod_Toolbox_RG' -Name 'Prod_Toolbox_vNet'


add-AzureRmVirtualNetworkPeering -name Link1 -VirtualNetwork $vnet1 -RemoteVirtualNetworkId $vnet2.id
Add-AzureRmVirtualNetworkPeering -name Link2 -VirtualNetwork $vnet2 -RemoteVirtualNetworkId $vnet1.id
