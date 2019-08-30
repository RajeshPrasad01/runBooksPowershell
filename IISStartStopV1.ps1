$myAutomationConnection = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzureRmAccount -CertificateThumbprint $myAutomationConnection.CertificateThumbprint -ApplicationId $myAutomationConnection.ApplicationId -ServicePrincipal -Tenant $myAutomationConnection.TenantId -Subscription $myAutomationConnection.SubscriptionId

$myAuzureContext = Select-AzureRmSubscription -Subscription $myAutomationConnection.SubscriptionId

$myIISServiceStatus = Get-Service -Name W3SVC -ComputerName myVMWin7475 
If ($myIISServiceStatus.Status -ne "Running") {
Write-Output "IIS Service not Running.. Status is .." $myIISServiceStatus.Status
Write-Output "Trying to start .."
Start-Service -Name W3SVC 
}
Start-Sleep -Seconds 5
$myIISServiceStatus = Get-Service -Name W3SVC -ComputerName myVMWin7475
If ($myIISServiceStatus.Status -ne "Running") {
Write-Output "Failed to Stop IIS Service .. trying again with force.."
Stop-Service -Name W3SVC -Force
Start-Service -Name W3SVC 
$myIISServiceStatus2 = Get-Service -Name W3SVC -ComputerName myVMWin7475

    If ($myIISServiceStatus2.Status -eq "Running" ) { Write-Output "IIS Service Started Successfully on 2nd Attempt... Status is ..."  $myIISServiceStatus.Status}
     else { Write-Output "Failed to Stop IIS Service on 2nd Attempt .. check manually.." }
} else { write-output "IIS Service is Running ..."}
