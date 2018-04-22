Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
New-AzureRmRecoveryServicesVault -Name "SPvault" -ResourceGroupName CTBSP2010 -location 'North Europe'

$vault1 = Get-AzureRmRecoveryServicesVault –Name "SPvault"
Set-AzureRmRecoveryServicesBackupProperties  -Vault $vault1 -BackupStorageRedundancy GeoRedundant -Location 'North Europe'

Get-AzureRmRecoveryServicesVault -Name SPvault | Set-AzureRmRecoveryServicesVaultContext

Get-AzureRmRecoveryServicesBackupProtectionPolicy -WorkloadType AzureVM
Name                 WorkloadType       BackupManagementType BackupTime                DaysOfWeek
----                 ------------       -------------------- ----------                ----------
DefaultPolicy        AzureVM            AzureVM              4/14/2016 5:00:00 PM

$schPol = Get-AzureRmRecoveryServicesBackupSchedulePolicyObject -WorkloadType "AzureVM"
$retPol = Get-AzureRmRecoveryServicesBackupRetentionPolicyObject -WorkloadType "AzureVM"
 New-AzureRmRecoveryServicesBackupProtectionPolicy -Name "SPPolicy" -WorkloadType AzureVM -RetentionPolicy $retPol -SchedulePolicy $schPol

Name                 WorkloadType       BackupManagementType BackupTime                DaysOfWeek
----                 ------------       -------------------- ----------                ----------
NewPolicy           AzureVM            AzureVM              4/24/2016 1:30:00 AM

$pol=Get-AzureRmRecoveryServicesBackupProtectionPolicy -Name "SPPolicy"
Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name "CTBSP2010" -ResourceGroupName "CTBSP2010"

$namedContainer = Get-AzureRmRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered" -Name "CTBSP2010"
$item = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"
$job = Backup-AzureRmRecoveryServicesBackupItem -Item $item

WorkloadName     Operation            Status               StartTime                 EndTime                   JobID
------------     ---------            ------               ---------                 -------                   ----------
V2VM              Backup               InProgress            4/23/2016 5:00:30 PM                       cf4b3ef5-2fac-4c8e-a215-d2eba4124f27


##Monotoring backup:
$joblist = Get-AzureRmRecoveryservicesBackupJob –Status InProgress
$joblist[0]

WorkloadName     Operation            Status               StartTime                 EndTime                   JobID
------------     ---------            ------               ---------                 -------                   ----------
V2VM   

          Backup               InProgress            4/23/2016 5:00:30 PM           cf4b3ef5-2fac-4c8e-a215-d2eba4124f27

          ##REF:https://azure.microsoft.com/en-in/documentation/articles/backup-azure-vms-automation/