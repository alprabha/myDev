Login-AzureRmAccount
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

        $vmname1 = 'CTBSTGRDS'
          $vmname2 = 'CTBSTGSQL'
          $vmname3 = 'CTBSTGSP'

            
           

        $vm = Get-AzureRmVm -ResourceGroupName $rgName -Name $vmName1 

         $vm | Start-AzureRmVm  

        $vm = Get-AzureRmVm -ResourceGroupName $rgName -Name $vmName2

          $vm | Start-AzureRmVm  

        $vm = Get-AzureRmVm -ResourceGroupName $rgName -Name $vmName3

          $vm | Start-AzureRmVm  

          
        $vm = Get-AzureRmVm -ResourceGroupName $rgName -Name 'CTBSTGRDS'

          $vm | Start-AzureRmVm 
