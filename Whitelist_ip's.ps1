
https://blogs.technet.microsoft.com/keithmayer/2016/01/12/step-by-step-automate-building-outbound-network-security-groups-rules-via-azure-resource-manager-arm-and-powershell/

http://www.systemsup.co.uk/network-security-groups-azure-learnt/

$downloadUri = "https://www.microsoft.com/en-in/download/confirmation.aspx?id=41653"

$downloadPage = Invoke-WebRequest -Uri $downloadUri

$xmlFileUri = ($downloadPage.RawContent.Split('"') -like "https://*PublicIps*")[0]

$response = Invoke-WebRequest -Uri $xmlFileUri


[xml]$xmlResponse = [System.Text.Encoding]::UTF8.GetString($response.Content)
$regions = $xmlResponse.AzurePublicIpAddresses.Region


$selectedRegions =
    $regions.Name |
    Out-GridView `
        -Title "Select Azure Datacenter Regions …" `
        -PassThru


 $ipRange = 
    ( $regions | 
      where-object Name -In $selectedRegions ).IpRange



$rules = @()

$rulePriority = 500

ForEach ($subnet in $ipRange.Subnet) {

    $ruleName = "Allow_Out_AZwhitelist" + $subnet.Replace("/","-")
    
    $rules += 
        New-AzureRmNetworkSecurityRuleConfig `
            -Name $ruleName `
            -Description "Allow outbound to Azure $subnet" `
            -Access Allow `
            -Protocol * `
            -Direction Outbound `
            -Priority $rulePriority `
            -SourceAddressPrefix VirtualNetwork `
            -SourcePortRange * `
            -DestinationAddressPrefix "$subnet" `
            -DestinationPortRange *

    $rulePriority++

}

$location = "North Europe"

$nsgName = "DMZ_NSG_RDS"
$rgName = "DMZ_Toolbox_RG"


$nsg = 
    New-AzureRmNetworkSecurityGroup `
       -Name $nsgName `
       -ResourceGroupName $rgName `
       -Location $location `
       -SecurityRules $rules





$ipRange.Subnet | Export-CSV IP.CSV

