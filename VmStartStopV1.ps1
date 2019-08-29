
$myAutomationConnection = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzureRmAccount -CertificateThumbprint $myAutomationConnection.CertificateThumbprint -ApplicationId $myAutomationConnection.ApplicationId -ServicePrincipal -Tenant $myAutomationConnection.TenantId -Subscription $myAutomationConnection.SubscriptionId

$myAuzureContext = Select-AzureRmSubscription -Subscription $myAutomationConnection.SubscriptionId

$myVMs = Get-AzureRmVm -ResourceGroupName TestRG 
Foreach ($myVm in $myVMs.Name) {

Write-Output "Stopping Vm .." $myVm
Start-AzureRmVm -Name $myVM -ResourceGroupName TestRG -StayProvisioned -Force 
$myVmStatus = Get-AzureRmVm -ResourceGroupName TestRG -Name $myVm -Status 

If ($myVmStatus.Statuses[1].DisplayStatus -ne "VM running") { 
Write-Output $myVm  $myVmStatus.Statuses[1].DisplayStatus
} else {
Write-output "Vm failed to stopped .." $myVm $myVmStatus.Statuses[1].DisplayStatus
}
}



