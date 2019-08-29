
$myAutomationConnection = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzureRmAccount -CertificateThumbprint $myAutomationConnection.CertificateThumbprint -ApplicationId $myAutomationConnection.ApplicationId -ServicePrincipal -Tenant $myAutomationConnection.TenantId -Subscription $myAutomationConnection.SubscriptionId

$myAuzureContext = Select-AzureRmSubscription -Subscription $myAutomationConnection.SubscriptionId

$myLocalCred = Get-AutomationPSCredential -Name "myLocalCred"

$myRSATState = Get-WindowsFeature -Name RSAT -Credential $myLocalCred
If ($myRSATState.InstallState -eq "Available") {
Install-WindowsFeature -Name RSAT -IncludeAllSubFeature -Credential $myLocalCred
} else {
write-ouput "RSAT Feature not Available, Cant Install" 
$myRSATState = Get-WindowsFeature -Name RSAT -Credential $myLocalCred
If ($myRSATState.Installed -eq $True) { 
Write-output "Installed Successfully"
} else {
Write-output "Failed To Install" 
}
