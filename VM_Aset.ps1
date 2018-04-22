get-azurerm
        $subscriptionid =
            
           ( Get-AzureRmSubscription | Out-GridView `
                  -Title "Select an Azure Resource Group ..." `
                  -PassThru
           ).SubscriptionId

        $rgName =
            
           ( Get-AzureRmResourceGroup | Out-GridView `
                  -Title "Select an Azure Resource Group ..." `
                  -PassThru
           ).ResourceGroupName

        $vmname =
            
           ( Get-AzureRmvm -ResourceGroupName $rgName | Out-GridView `
                  -Title "Select an Azure VM ..." `
                  -PassThru
           ).Name

        $vm = Get-AzureRmVm -ResourceGroupName $rgName -Name $vmName 

         
        $location = $vm.Location 


        $asName = Read-Host -Prompt "Enter a new Availability Set name" 

  
        $as = New-AzureRmAvailabilitySet -Name $asName -ResourceGroupName $rgName -Location $location 
       ## $as = get-AzureRmAvailabilitySet $rgName -name DMZ_RDS_AVset
        $vm | Stop-AzureRmVm -Force 
 
        $vm | Remove-AzureRmVm -Force 

        $asRef = New-Object Microsoft.Azure.Management.Compute.Models.SubResource 

 
        $asRef.Id = $as.Id 

        $vm.AvailabilitySetReference = $asRef # To remove VM from Availability Set, set to $null 


        $vm.StorageProfile.OSDisk.Name = $vmName
        $vm.StorageProfile.OSDisk.CreateOption = "Attach"
        $vm.StorageProfile.DataDisks | ForEach-Object { $_.CreateOption = "Attach" } 
            $vm.StorageProfile.ImageReference = $null
            $vm.OSProfile = $null

        $vm | New-AzureRmVm -ResourceGroupName $rgName -Location $location 



