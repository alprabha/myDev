	
Get-AzureRMNetworkSecurityGroup -Name prod_db_nsg -ResourceGroupName prod_toolbox_rg | Set-AzureRmNetworkSecurityRuleConfig -Name "Allow_RDS_layer" -Direction inbound -Priority 110 -Access Allow -SourceAddressPrefix '10.1.10.0/27'  -SourcePortRange '*' -DestinationAddressPrefix '*' -DestinationPortRange '3389' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

Get-AzureRMNetworkSecurityGroup -Name DMZ_ad_nsg -ResourceGroupName dmz_toolbox_rg | add-AzureRmNetworkSecurityRuleConfig -Name "Allow_RDS_Inbound" | Set-AzureRmNetworkSecurityGroup

Get-AzureRmNetworkSecurityGroup -Name  DMZ_rds_nsg -ResourceGroupName dmz_toolbox_rg  | Remove-AzureRmNetworkSecurityRuleConfig -Name "internet-rule"  | Set-AzureRmNetworkSecurityGroup
	


Get-AzureRMNetworkSecurityGroup -Name DMZ_rds_nsg -ResourceGroupName dmz_toolbox_rg | set-AzureRmNetworkSecurityRuleConfig -Name "Allwo-deny_RDP" -Direction inbound -Priority 150 -Access allow -SourceAddressPrefix '10.1.10.0/27'  -SourcePortRange '*' -DestinationAddressPrefix 'VirtualNetwork' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup
Get-AzureRMNetworkSecurityGroup -Name Prod_DB_NSG -ResourceGroupName prod_toolbox_rg | add-AzureRmNetworkSecurityRuleConfig -Name "Allow_vNet" -Direction outbound -Priority 100 -Access Allow -SourceAddressPrefix 'VirtualNetwork'  -SourcePortRange '*' -DestinationAddressPrefix 'VirtualNetwork' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

Get-AzureRmNetworkSecurityGroup -Name  NSG-BackEnd -ResourceGroupName ctbstg2013  | Add-AzureRmNetworkSecurityRuleConfig -Name "Allow_SQL" -Direction Outbound -Priority 100 -Access Allow -SourceAddressPrefix '*'  -SourcePortRange '*' -DestinationAddressPrefix '10.10.10.0/29' -DestinationPortRange '1433' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

Get-AzureRmNetworkSecurityGroup -Name  NSG-BackEnd -ResourceGroupName ctbstg2013  | Add-AzureRmNetworkSecurityRuleConfig -Name "Block_Inbound" -Direction inbound -Priority 500 -Access Deny -SourceAddressPrefix '*'  -SourcePortRange '*' -DestinationAddressPrefix '*' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

Get-AzureRmNetworkSecurityGroup -Name  Mgmt_vNic_NSG -ResourceGroupName Prod_toolbox_rg  | Add-AzureRmNetworkSecurityRuleConfig -Name "Block_Prod_Inbound" -Direction inbound -Priority 200 -Access Deny -SourceAddressPrefix 'VirtualNetwork'  -SourcePortRange '*' -DestinationAddressPrefix '*' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

Get-AzureRmNetworkSecurityGroup -Name  Stg_NSG_RDS -ResourceGroupName CTBSTG2013  | Add-AzureRmNetworkSecurityRuleConfig -Name "Allow_vNet" -Direction Outbound -Priority 400 -Access Allow -SourceAddressPrefix 'VirtualNetwork'  -SourcePortRange '*' -DestinationAddressPrefix 'VirtualNetwor' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

Get-AzureRmNetworkSecurityGroup -Name  DMZ_NSG_RDS -ResourceGroupName DMZ_Toolbox_RG  | Add-AzureRmNetworkSecurityRuleConfig -Name "Allow_vNet" -Direction Outbound -Priority 200 -Access Allow -SourceAddressPrefix 'VirtualNetwork'  -SourcePortRange '*' -DestinationAddressPrefix 'VirtualNetwork' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

Get-AzureRmNetworkSecurityGroup -Name  DMZ_NSG_RDS -ResourceGroupName DMZ_Toolbox_RG  | Add-AzureRmNetworkSecurityRuleConfig -Name "Block_All_Outbound" -Direction Outbound -Priority 300 -Access Deny -SourceAddressPrefix 'VirtualNetwork'  -SourcePortRange '*' -DestinationAddressPrefix 'Internet' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

Get-AzureRmNetworkSecurityGroup -Name  DMZ_NSG_RDS -ResourceGroupName DMZ_Toolbox_RG  | Add-AzureRmNetworkSecurityRuleConfig -Name "Block_All_Outbound" -Direction Outbound -Priority 900 -Access Deny -SourceAddressPrefix '*'  -SourcePortRange '*' -DestinationAddressPrefix '*' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup


Get-AzureRmNetworkSecurityGroup -Name  DMZ_NSG_RDS -ResourceGroupName DMZ_Toolbox_RG  | Add-AzureRmNetworkSecurityRuleConfig -Name "SSL_Rule" -Direction inbound -Priority 100 -Access Allow -SourceAddressPrefix 'Internet'  -SourcePortRange '*' -DestinationAddressPrefix '*' -DestinationPortRange '443' -Protocol '*' | Set-AzureRmNetworkSecurityGroup
Get-AzureRmNetworkSecurityGroup -Name  DMZ_NSG_RDS -ResourceGroupName DMZ_Toolbox_RG  | Add-AzureRmNetworkSecurityRuleConfig -Name "Allow_RDP_RDS" -Direction inbound -Priority 200 -Access Allow -SourceAddressPrefix '10.1.10.0/27'  -SourcePortRange '*' -DestinationAddressPrefix 'VirtualNetwork' -DestinationPortRange '3389' -Protocol '*' | Set-AzureRmNetworkSecurityGroup
Get-AzureRmNetworkSecurityGroup -Name  DMZ_NSG_RDS -ResourceGroupName DMZ_Toolbox_RG  | Add-AzureRmNetworkSecurityRuleConfig -Name "Block_All_Inbound" -Direction inbound -Priority 500 -Access Deny -SourceAddressPrefix '*'  -SourcePortRange '*' -DestinationAddressPrefix '*' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup







Get-AzureRmNetworkSecurityGroup -Name  Stg_NSG_RDS -ResourceGroupName CTBSTG2013  | securityrules $rules | Set-AzureRmNetworkSecurityGroup

Get-AzureRmNetworkSecurityGroup -Name  Stg_NSG_RDS -ResourceGroupName dmz_toolbox_rg  | Set-AzureRmNetworkSecurityGroup

Deny
Get-AzureRMNetworkSecurityGroup -Name prod_app_nsg -ResourceGroupName prod_toolbox_rg | add-AzureRmNetworkSecurityRuleConfig -Name "Deny_All_Inbound" -Direction inbound -Priority 200 -Access Deny -SourceAddressPrefix '10.1.10.0/27'  -SourcePortRange '*' -DestinationAddressPrefix '*' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup



                        New-AzureRmNetworkSecurityRuleConfig -Name frontend-sqlrule -Description "Allow FE subnet" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix $SubNet1Prefix -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 1433
RDS

Get-AzureRMNetworkSecurityGroup -Name Prod_App_NSG -ResourceGroupName prod_toolbox_rg | add-AzureRmNetworkSecurityRuleConfig -Name "Allow_SP_Ports" -Direction inbound -Priority 350 -Access Allow -SourceAddressPrefix '10.20.0.0/16'  -SourcePortRange '*' -DestinationAddressPrefix 'VirtualNetwork' -DestinationPortRange '22233-22236' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

Get-AzureRMNetworkSecurityGroup -Name Prod_db_NSG -ResourceGroupName prod_toolbox_rg | add-AzureRmNetworkSecurityRuleConfig -Name "Allow_DB_Inbound" -Direction inbound -Priority 100 -Access Allow -SourceAddressPrefix '10.20.50.0/27'  -SourcePortRange '*' -DestinationAddressPrefix 'VirtualNetwork' -DestinationPortRange '*' -Protocol '*' | Set-AzureRmNetworkSecurityGroup

