$loc = 'northeurope'
Get-AzureRmVMImagePublisher -Location $loc
Get-AzureRmVMImageOffer -Location $loc -PublisherName "MicrosoftWindowsServer"
Get-AzureRmVMImageSku -Location $loc -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer"

$loc = 'northeurope'
Get-AzureRmVMImagePublisher -Location $loc
Get-AzureRmVMImageOffer -Location $loc -PublisherName "docker"
Get-AzureRmVMImageSku -Location $loc -PublisherName "docker" -Offer "docker-ee"