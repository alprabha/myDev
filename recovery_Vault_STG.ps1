Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
New-AzureRmRecoveryServicesVault -Name "CTBProd-Vault" -ResourceGroupName Prod_Toolbox_RG -location 'North Europe'

$vault1 = Get-AzureRmRecoveryServicesVault –Name "CTBProd-Vault"
Set-AzureRmRecoveryServicesBackupProperties  -Vault $vault1 -BackupStorageRedundancy LocallyRedundant -Location 'North Europe'

Get-AzureRmRecoveryServicesVault -Name "CTBProd-Vault" | Set-AzureRmRecoveryServicesVaultContext

Get-AzureRmRecoveryServicesBackupProtectionPolicy -WorkloadType AzureVM
Name                 WorkloadType       BackupManagementType BackupTime                DaysOfWeek
----                 ------------       -------------------- ----------                ----------
DefaultPolicy        AzureVM            AzureVM              4/14/2016 5:00:00 PM

$schPol = Get-AzureRmRecoveryServicesBackupSchedulePolicyObject -WorkloadType "AzureVM"
$retPol = Get-AzureRmRecoveryServicesBackupRetentionPolicyObject -WorkloadType "AzureVM"
 New-AzureRmRecoveryServicesBackupProtectionPolicy -Name "prodPolicy" -WorkloadType AzureVM -RetentionPolicy $retPol -SchedulePolicy $schPol

 ## Edit the policy as required 

Name                 WorkloadType       BackupManagementType BackupTime                DaysOfWeek
----                 ------------       -------------------- ----------                ----------
NewPolicy           AzureVM            AzureVM              4/24/2016 1:30:00 AM

$pol=Get-AzureRmRecoveryServicesBackupProtectionPolicy -Name "ProdPolicy"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "CTBPRODWEBSRV1" -ResourceGroupName "Prod_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "CTBPRODWEBSRV2" -ResourceGroupName "Prod_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "CTBPRODAPPSRV1" -ResourceGroupName "Prod_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "CTBPRODAPPSRV2" -ResourceGroupName "Prod_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "CTBPRODDB-N1" -ResourceGroupName "Prod_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "CTBPRODDB-N2" -ResourceGroupName "Prod_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "CTBPRODDB-fsw" -ResourceGroupName "Prod_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "DMZCTBADDC1" -ResourceGroupName "DMZ_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "DMZCTBADDC2" -ResourceGroupName "DMZ_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "DMZCTBRDSSRV1" -ResourceGroupName "DMZ_Toolbox_RG"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "DMZCTBRDSSRV2" -ResourceGroupName "DMZ_Toolbox_RG"




$namedContainer = Get-AzureRmRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered" -Name "CTBPRODDB-fsw"
$item = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"
$job = Backup-AzureRmRecoveryServicesBackupItem -Item $item

$namedContainer = Get-AzureRmRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered" -Name "DMZCTBADDC2"
$item = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"
$job = Backup-AzureRmRecoveryServicesBackupItem -Item $item

WorkloadName     Operation            Status               StartTime                 EndTime                   JobID
------------     ---------            ------               ---------                 -------                   ----------
V2VM              Backup               InProgress            4/23/2016 5:00:30 PM                       cf4b3ef5-2fac-4c8e-a215-d2eba4124f27


##Monotoring backup:
$joblist = Get-AzureRmRecoveryservicesBackupJob –Status InProgress
$joblist >>I:\Status.txt
$joblist[0]

WorkloadName     Operation            Status               StartTime                 EndTime                   JobID
------------     ---------            ------               ---------                 -------                   ----------
V2VM   

          Backup               InProgress            4/23/2016 5:00:30 PM           cf4b3ef5-2fac-4c8e-a215-d2eba4124f27

          ##REF:https://azure.microsoft.com/en-in/documentation/articles/backup-azure-vms-automation/