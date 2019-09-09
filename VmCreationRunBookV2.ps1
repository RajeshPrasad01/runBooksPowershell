Workflow myVMCreationRunBook
{

$myAutomationConnection = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzureRmAccount -CertificateThumbprint $myAutomationConnection.CertificateThumbprint -ApplicationId $myAutomationConnection.ApplicationId -ServicePrincipal -Tenant $myAutomationConnection.TenantId -Subscription $myAutomationConnection.SubscriptionId

$myTestRG = New-AzureRmResourceGroup -Name RecoveryRG -Location EastUs2

Select-AzureRmSubscription -Subscription $myAutomationConnection.SubscriptionId

#####  NSG ######
Parallel { 

InlineScript {
$myNSGConfig7475 = New-AzureRmNetworkSecurityRuleConfig -Name "AllowRDP7475" -Description "Allow RDP" -Protocol Tcp -SourcePortRange * -DestinationPortRange 3389 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.1.0/24" -Access Allow -Priority 200 -Direction Inbound
$myNSg7475 = New-AzureRmNetworkSecurityGroup -Name "myNSG7475" -ResourceGroupName TestRG -Location 'East US 2' -SecurityRules $myNSGConfig7475
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowHTTP7475" -NetworkSecurityGroup $myNSG7475 -Description "Allow HTTP" -Protocol Tcp -SourcePortRange * -DestinationPortRange 80 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.1.0/24" -Access Allow -Priority 300 -Direction Inbound
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowHTTPS7475" -NetworkSecurityGroup $myNSG7475 -Description "Allow HTTPS" -Protocol Tcp -SourcePortRange * -DestinationPortRange 443 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.1.0/24" -Access Allow -Priority 400 -Direction Inbound
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowSSH7475" -NetworkSecurityGroup $myNSG7475 -Description "Allow SSH" -Protocol Tcp -SourcePortRange * -DestinationPortRange 22 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.1.0/24" -Access Allow -Priority 500 -Direction Inbound
Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $myNSG7475 -AsJob
}

InlineScript {
$myNSGConfigNICProdSubnet = New-AzureRmNetworkSecurityRuleConfig -Name "AllowRDPNICProdSubnet" -Description "Allow RDP" -Protocol Tcp -SourcePortRange * -DestinationPortRange 3389 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.1.0/24" -Access Allow -Priority 200 -Direction Inbound
$myNSgNICProdSubnet = New-AzureRmNetworkSecurityGroup -Name "myNSGNICProdSubnet" -ResourceGroupName TestRG -Location 'East US 2' -SecurityRules $myNSGConfigNICProdSubnet
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowHTTPNICProdSubnet" -NetworkSecurityGroup $myNSgNICProdSubnet -Description "Allow HTTP" -Protocol Tcp -SourcePortRange * -DestinationPortRange 80 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.1.0/24" -Access Allow -Priority 300 -Direction Inbound
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowHTTPSNICProdSubnet" -NetworkSecurityGroup $myNSgNICProdSubnet -Description "Allow HTTPS" -Protocol Tcp -SourcePortRange * -DestinationPortRange 443 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.1.0/24" -Access Allow -Priority 400 -Direction Inbound
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowSSHNICProdSubnet" -NetworkSecurityGroup $myNSgNICProdSubnet -Description "Allow SSH" -Protocol Tcp -SourcePortRange * -DestinationPortRange 22 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.1.0/24" -Access Allow -Priority 500 -Direction Inbound
Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $myNSgNICProdSubnet -AsJob
}

InlineScript {
$myNSGConfigDevSubnet = New-AzureRmNetworkSecurityRuleConfig -Name "AllowRDPDevSubnet" -Description "Allow RDP" -Protocol Tcp -SourcePortRange * -DestinationPortRange 3389 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.2.0/24" -Access Allow -Priority 200 -Direction Inbound
$myNSgDevSubnet = New-AzureRmNetworkSecurityGroup -Name "myNSGDevSubnet" -ResourceGroupName TestRG -Location 'East US 2' -SecurityRules $myNSGConfigDevSubnet
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowHTTPDevSubnet" -NetworkSecurityGroup $myNSgDevSubnet -Description "Allow HTTP" -Protocol Tcp -SourcePortRange * -DestinationPortRange 80 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.2.0/24" -Access Allow -Priority 300 -Direction Inbound
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowHTTPSDevSubnet" -NetworkSecurityGroup $myNSgDevSubnet -Description "Allow HTTPS" -Protocol Tcp -SourcePortRange * -DestinationPortRange 443 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.2.0/24" -Access Allow -Priority 400 -Direction Inbound
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowSSHDevSubnet" -NetworkSecurityGroup $myNSgDevSubnet -Description "Allow SSH" -Protocol Tcp -SourcePortRange * -DestinationPortRange 22 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.2.0/24" -Access Allow -Priority 500 -Direction Inbound
Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $myNSgDevSubnet -AsJob
}

InlineScript {
$myNSGConfigNiCDevSubnet = New-AzureRmNetworkSecurityRuleConfig -Name "AllowRDPNiCDevSubnet" -Description "Allow RDP" -Protocol Tcp -SourcePortRange * -DestinationPortRange 3389 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.2.0/24" -Access Allow -Priority 200 -Direction Inbound
$myNSgNiCDevSubnet = New-AzureRmNetworkSecurityGroup -Name "myNSGNiCDevSubnet" -ResourceGroupName TestRG -Location 'East US 2' -SecurityRules $myNSGConfigNiCDevSubnet
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowHTTPDevSubnet" -NetworkSecurityGroup $myNSgNiCDevSubnet -Description "Allow HTTP" -Protocol Tcp -SourcePortRange * -DestinationPortRange 80 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.2.0/24" -Access Allow -Priority 300 -Direction Inbound
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowHTTPSDevSubnet" -NetworkSecurityGroup $myNSgNiCDevSubnet -Description "Allow HTTPS" -Protocol Tcp -SourcePortRange * -DestinationPortRange 443 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.2.0/24" -Access Allow -Priority 400 -Direction Inbound
Add-AzureRmNetworkSecurityRuleConfig -Name "AllowSSHDevSubnet" -NetworkSecurityGroup $myNSgNiCDevSubnet -Description "Allow SSH" -Protocol Tcp -SourcePortRange * -DestinationPortRange 22 -SourceAddressPrefix Internet -DestinationAddressPrefix "10.0.2.0/24" -Access Allow -Priority 500 -Direction Inbound
Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $myNSgNiCDevSubnet -AsJob
}
}

CheckPoint-WorkFlow

#### Virtualnetwork ###########

$myNSgProdSubnet = Get-AzureRmNetworkSecurityGroup -Name myNSG7475 -ResourceGroupName TestRG 
$myNSgDevSubnet = Get-AzureRmNetworkSecurityGroup -Name myNSGDevSubnet -ResourceGroupName TestRG

Parallel {

InlineScript {
$myProbSubnetConfig7475 = New-AzureRmVirtualNetworkSubnetConfig -Name ProdSubnet7475 -AddressPrefix "10.0.1.0/24" -NetworkSecurityGroupId $myNSgProdSubnet.Id
$myDevSubnetConfig7475 = New-AzureRmVirtualNetworkSubnetConfig -Name DevSubnet7475 -AddressPrefix "10.0.2.0/24" -NetworkSecurityGroupId $myNSgDevSubnet.Id
$myApplicationGatewaySubnet7475 = New-AzureRmVirtualNetworkSubnetConfig -Name ApplicationGatewaySubnet7475 -AddressPrefix "10.0.100.0/24"
New-AzureRmVirtualnetwork -Name VirtualNetwork7475 -ResourceGroupName TestRG -Location EastUs2 -AddressPrefix "10.0.0.0/16" -Subnet $myProbSubnetConfig7475, $myDevSubnetConfig7475, $myApplicationGatewaySubnet7475
$myVirtualNetwork7475 = Get-AzureRmVirtualNetwork -Name VirtualNetwork7475 -ResourceGroupName TestRG 
Add-AzureRmVirtualNetworkSubnetConfig -Name GatewaySubnet -VirtualNetwork $myVirtualNetwork7475 -AddressPrefix "10.0.200.0/24" 
Set-AzureRmVirtualnetwork -VirtualNetwork $myVirtualnetwork7475 -AsJob
}

InlineScript {
$myProbSubnetConfig7476 = New-AzureRmVirtualNetworkSubnetConfig -Name ProdSubnet7476 -AddressPrefix "172.25.1.0/24" 
$myDevSubnetConfig7476 = New-AzureRmVirtualNetworkSubnetConfig -Name DevSubnet7476 -AddressPrefix "172.25.2.0/24"
$myApplicationGatewaySubnet7476 = New-AzureRmVirtualNetworkSubnetConfig -Name ApplicationGatewaySubnet7476 -AddressPrefix "172.25.100.0/24"
New-AzureRmVirtualnetwork -Name VirtualNetwork7476 -ResourceGroupName TestRG -Location EastUs -AddressPrefix "172.25.0.0/16" -Subnet $myProbSubnetConfig7476, $myDevSubnetConfig7476, $myApplicationGatewaySubnet7476 
$myVirtualNetwork7476 = Get-AzureRmVirtualNetwork -Name VirtualNetwork7476 -ResourceGroupName TestRG 
Add-AzureRmVirtualNetworkSubnetConfig -Name GatewaySubnet -VirtualNetwork $myVirtualNetwork7476 -AddressPrefix "172.25.200.0/24" 
Set-AzureRmVirtualnetwork -VirtualNetwork $myVirtualnetwork7476 -AsJob
}
}

CheckPoint-WorkFlow


Parallel {

InlineScript {
### Create WebApp ###
New-AzureRmAppServicePlan -Location 'East US 2' -Tier Free -NumberofWorkers 1 -WorkerSize Small -ResourceGroupName TestRG -Name myAppServicePlan7475Free 
$myAppServicePlan = Get-AzureRmAppServicePlan -ResourceGroupName TestRG -Name myAppServicePlan7475Free 
New-AzureRmWebApp -ResourceGroupName TestRG -Name myWebApp7475 -Location 'East US 2' -AppServicePlan myAppServicePlan7475Free 
$myWebApp = Get-AzureRmWebApp -ResourceGroupName TestRG -Name myWebApp7475
}


InlineScript {
### Create Vms #####

$myPass = ConvertTo-SecureString -String "Happy@200789" -AsPlainText -Force 
$myCred = New-object -TypeName System.Management.Automation.PSCredential ("rajesh.prasad0", $myPass) 

New-AzureRmPublicIpAddress -Name PublicIP7475 -ResourceGroupName TestRG -Location 'East US 2' -Sku Basic -AllocationMethod Dynamic -IpAddressVersion IPv4 

Write-Output "########################################### Creating VM ... $myString ########################################### "

$myRandomNumber = Get-Random -Maximum 99 -Minimum 10
$myString = "747580"
$myResourceGroup = Get-AzureRmResourceGroup -Name TestRG -Location 'East US 2'
$myPrivateAddress = "10.0.1.10"
$myVirtualNetwork = Get-AzureRmVirtualnetwork -Name VirtualNetwork7475 -ResourceGroupName $myResourceGroup.ResourceGroupName
$myLocationName = "EastUS2"
$myPublicIPVM = Get-AzureRmPublicIpAddress -Name PublicIP7475 -ResourceGroupName TestRG
$myNSGNic = Get-AzureRmNetworkSecurityGroup -Name myNSGNICProdSubnet  -ResourceGroupName $myResourceGroup.ResourceGroupName
$mySA = Get-AzureRmStorageAccount -ResourceGroupName TestResourceGroup -Name mystor7475 

Start-sleep -Seconds 30

$myVirtualnetwork7475 = Get-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name VirtualNetwork7475 
$myVirtualnetwork7476 = Get-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name VirtualNetwork7476

Set-AzureRmDiagnosticSetting -ResourceId $myVirtualnetwork7475.Id -Name myDSSVirtualNetwork7475 -WorkspaceId $myLogAnalyticsWorkSpace.ResourceId -Enabled $true 
Set-AzureRmDiagnosticSetting -ResourceId $myVirtualnetwork7476.Id -Name myDSSVirtualNetwork7476 -WorkspaceId $myLogAnalyticsWorkSpace.ResourceId -Enabled $true 

$myNSG7475 = Get-AzureRmNetworkSecurityGroup -Name myNSG7475 -ResourceGroupName TestRG

$myNSGDevSubnet = Get-AzureRmNetworkSecurityGroup -Name myNSGDevSubnet -ResourceGroupName TestRG
$myNSGNiCDevSubnet = Get-AzureRmNetworkSecurityGroup -Name myNSGNiCDevSubnet -ResourceGroupName TestRG
$myNSGNICProdSubnet = Get-AzureRmNetworkSecurityGroup -Name myNSGNICProdSubnet -ResourceGroupName TestRG

Set-AzureRmDiagnosticSetting -ResourceId $myNSG7475.Id -Name myDSSVirtualNetwork7475 -WorkspaceId $myLogAnalyticsWorkSpace.ResourceId -Enabled $true 
Set-AzureRmDiagnosticSetting -ResourceId $myNSGDevSubnet.Id -Name myDSSVirtualNetwork7475 -WorkspaceId $myLogAnalyticsWorkSpace.ResourceId -Enabled $true 
Set-AzureRmDiagnosticSetting -ResourceId $myNSGNiCDevSubnet.Id -Name myDSSVirtualNetwork7475 -WorkspaceId $myLogAnalyticsWorkSpace.ResourceId -Enabled $true 
Set-AzureRmDiagnosticSetting -ResourceId $myNSGNICProdSubnet.Id -Name myDSSVirtualNetwork7475 -WorkspaceId $myLogAnalyticsWorkSpace.ResourceId -Enabled $true 


$myProdSubnet = Get-AzureRmVirtualNetworkSubnetConfig -Name ProdSubnet7475 -VirtualNetwork $myVirtualNetwork
$myNetworkIpConfig = New-AzureRmNetworkInterfaceIpConfig -Name ("myVMWinNicIPConfig" + $myString) -PrivateIpAddressVersion IPv4 -PrivateIpAddress $myPrivateAddress -SubnetId $myProdSubnet.Id -PublicIpAddressId $myPublicIPVM.Id 
New-AzureRmNetworkInterface -Name ("myNicVMWin" + $myString) -ResourceGroupName $myResourceGroup.ResourceGroupName -Location $myLocationName -IpConfiguration $myNetworkIpConfig -NetworkSecurityGroupId $myNSGNic.Id
$myNic = Get-AzureRmNetworkInterface -Name ("myNicVMWin" + $myString) -ResourceGroupName $myResourceGroup.ResourceGroupName 

$myVmWinConfig = New-AzureRmVMConfig -VMName ("myVMWin" + $myString) -VMSize "Standard_b1s" 
$myVmWinConfig = Add-AzureRmVMNetworkInterface -VM $myVmWinConfig -NetworkInterface $myNic 
$myVmWinConfig = Set-AzureRmVMOperatingSystem -VM $myVmWinConfig -Windows -ComputerName ("myVMWin" + $myString) -Credential $myCred -ProvisionVMAgent -EnableAutoUpdate -TimeZone "India Standard Time" 
$myVmWinConfig = Set-AzureRmVMOSDisk -VM $myVmWinConfig -Name ("myVMDisk" + $myString) -Windows -CreateOption FromImage -StorageAccountType Standard_LRS -DiskSizeInGB 127
$myVmWinConfig = Set-AzureRmVMSourceImage -VM $myVmWinConfig -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version Latest 
$myVmWinConfig = Set-AzureRmVMBootDiagnostics -VM $myVmWinConfig -Enable -StorageAccountName $mySA.StorageAccountName -ResourceGroupName TestResourceGroup

New-AzureRmVm -ResourceGroupName $myResourceGroup.ResourceGroupName -Location $myLocationName -VM $myVmWinConfig 

$myVm = Get-AzureRmVm -ResourceGroupName $myResourceGroup.ResourceGroupName -Name ("myVMWin" + $myString)
$myVmName = $myVm.Name

$myVMDisk = Get-AzureRmDisk -ResourceGroupName $myResourceGroup.ResourceGroupName -DiskName ("myVMDisk" + $myString)
$myVmDiskSku = $myVMDisk.Sku.Name
Write-Output "Vm with name $myVm.Name has ... $myVmDiskSku"
$myStorageAccount = Get-AzureRmStorageAccount -ResourceGroupName TestResourceGroup -Name mystor7475
$myStorageAccountKey = Get-AzureRmStorageAccountKey -ResourceGroupName TestResourceGroup -Name mystor7475 
$myContainer = Get-AzureStorageContainer -Name mycontainer7476 -Context $myStorageAccount.Context 

$myLogAnalyticsWorkSpace = Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName RecoveryRG -Name myLogAnalytics7476
Set-AzureRmDiagnosticSetting -ResourceId $myVm.Id -Name myDSVMWin7475 -WorkspaceId $myLogAnalyticsWorkSpace.ResourceId -Enabled $true 

Write-output " Running extensions ..  $myVMName"
Set-AzureRmVMCustomScriptExtension -ResourceGroupName $myResourceGroup.ResourceGroupName -VMName $myVm.Name -Name "InstallScripts" -ContainerName $myContainer.Name -FileName "myScript.ps1" -StorageAccountName $myStorageAccount.StorageAccountName -TypeHandlerVersion "1.1" -Location $myLocationName -StorageAccountKey $myStorageAccountKey[0].Value -Run "myScript.ps1" -NoWait
Start-Sleep -Seconds 60

$myVMExtension = Get-AzureRmVMCustomScriptExtension -ResourceGroupName $myResourceGroup.ResourceGroupName -VMName $myVm.Name -Name "InstallScripts" -Status
$myVMExtension.Statuses.DisplayStatus
$myVmName = $myVm.Name
$myVMExtensionStatusesDisplayStatus = $myVMExtension.Statuses.DisplayStatus
$myVMExtensionStatusesMessage = $myVMExtension.Statuses.Message

If ($myVMExtensionStatusesDisplayStatus) {
    Write-output " Status of Extension on $myVmName is ... $myVMExtensionStatusesDisplayStatus and Status Message is $myVMExtensionStatusesMessage" }
    Else {
    Write-Output "`r`n Extension failed to install on Vm ..$myVMName" }

#Attach to log Analytics Workspace 
$myAutomationAccount = Get-AzureRmAutomationAccount -ResourceGroupName TestResourceGroup -Name myAutomationAccount7475 
$myAutomationScheduleWin = New-AzureRmAutomationSchedule -Name myWinUpdateSchedule -StartTime 13:30 -Description "Software update Schedule" -OneTime -ResourceGroupName TestResourceGroup -TimeZone "India Standard Time" -ForUpdateConfiguration -AutomationAccountName $myAutomationAccount.AutomationAccountName 
New-AzureRmAutomationSoftwareUpdateConfiguration -ResourceGroupName TestResourceGroup -Schedule $myAutomationScheduleWin -Windows -AzureVMResourceId $myVm.Id -Duration 180 -AutomationAccountName $myAutomationAccount.AutomationAccountName -RebootSetting IfRequired 

$myLogAnalyticsWorkSpace = Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName RecoveryRG -Name myLogAnalytics7476

# Activate an OMS solution (in this case - Change Tracking) in the workspace
Set-AzureRmOperationalInsightsIntelligencePack -ResourceGroupName RecoveryRG -WorkspaceName $myLogAnalyticsWorkSpace.Name -IntelligencePackName "ChangeTracking" -Enabled $true

# Create references to the WorkspaceId and WorkspaceKey
$myLogAnalyticsWorkSpaceId = $myLogAnalyticsWorkSpace.CustomerId
$myLogAnalyticsWorkSpaceKey = (Get-AzureRmOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $myLogAnalyticsWorkSpace.ResourceGroupName -Name $myLogAnalyticsWorkSpace.Name).PrimarySharedKey

# For Windows VM uncomment the following line
Set-AzureRmVMExtension -ResourceGroupName TestRG -VMName myVMWin747580 -Name 'MicrosoftMonitoringAgent' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location EastUs2 -SettingString "{'workspaceId': '$myLogAnalyticsWorkSpaceId'}" -ProtectedSettingString "{'workspaceKey': '$myLogAnalyticsWorkSpaceKey'}"

####################### Set Application Insigts Extension ##############################################

$myApplicationInsights = Get-AzureRmApplicationInsights -ResourceGroupName TestResourceGroup -Name myApplicationInsights7475
$myApplicationInsightsKey = Get-AzureRmResource -ResourceId $myApplicationInsights.Id 
$myApplicationInsightsKey.Properties.InstrumentationKey

$publicCfgJsonString = '
    {
        "RedfieldConfiguration": {
        "InstrumentationKeyMap": {
        "Filters": [
            {
                "AppFilter": ".*",
                "MachineFilter": ".*",
                "InstrumentationSettings" : {
                "InstrumentationKey": $myApplicationInsightsKey.Properties.InstrumentationKey
                }
            }
         ]
        }
    }
}
';
$privateCfgJsonString = '{}';

Set-AzureRmVMExtension -ResourceGroupName TestRG -VMName $myVm.Name -Location EastUs2 -Name "myApplicationInsigtsExtension" `
                       -Publisher "Microsoft.Azure.Diagnostics" -ExtensionType "ApplicationMonitoringWindows" -SettingString $publicCfgJsonString `
                       -ProtectedSettingString $privateCfgJsonString -TypeHandlerVersion "2.8" 


#########################################################################################################
}

CheckPoint-WorkFlow

InlineScript {
#######################Create Linux VM #####################################################################

Start-sleep -Seconds 30

$myVirtualNetwork = Get-AzureRmVirtualNetwork -Name VirtualNetwork7475 -ResourceGroupName TestRG 
$myDevSubnetConfig = Get-AzureRmVirtualnetworkSubnetConfig -Name DevSubnet7475 -VirtualNetwork $myVirtualNetwork
$myNSGNICLinux = Get-AzureRmNetworkSecurityGroup -Name myNSGNiCDevSubnet -ResourceGroupName TestRG

New-AzureRmPublicIpAddress -Name PublicIP7476 -ResourceGroupName TestRG -Location 'East US 2' -Sku Basic -AllocationMethod Dynamic -IpAddressVersion IPv4
$myPublicIP7476 = Get-AzureRmPublicIpAddress -Name PublicIP7476 -ResourceGroupName TestRG

$myNetworkIpConfig = New-AzureRmNetworkInterfaceIpConfig -Name myVMLinuxNicIPConfig -PrivateIpAddressVersion IPv4 -PrivateIpAddress "10.0.2.10" -SubnetId $myDevSubnetConfig.Id -PublicIpAddressId $myPublicIP7476.Id
$myLinuxNic = New-AzureRmNetworkInterface -Name myNicVMLinux7475 -ResourceGroupName TestRG -Location 'East US 2' -IpConfiguration $myNetworkIpConfig -NetworkSecurityGroupId $myNSGNICLinux.Id

$myVmAvailabilitySet = New-AzureRmAvailabilitySet -ResourceGroupName TestRG -Name myVmAvailabilitySet7475 -Location 'East US 2' -PlatformUpdateDomainCount 3 -PlatformFaultDomainCount 3 -Sku Aligned 

$myPassLinux = ConvertTo-SecureString -String "Happy@200789" -AsPlainText -Force 
$myCredLinux = New-object -TypeName System.Management.Automation.PSCredential ("rajesh", $myPassLinux) 

$myKeyVault = Get-AzureRmKeyVault -VaultName myKeyvault7478 -ResourceGroupName TestResourceGroup 
$myKeyVaultLinuxVMSecret = Get-AzureKeyVaultSecret -VaultName myKeyvault7478 -Name myLinuxVMLoginSecret -Version "10e4684997ad43bca243801586f53ee2"
$myLinuxKeyData = $myKeyVaultLinuxVMSecret.SecretValueText
$myStorageAccount = Get-AzureRmStorageAccount -ResourceGroupName TestResourceGroup -Name mystor7475 

$myVmConfigLinux = New-AzureRmVMConfig -VMName myLinuxVM7475 -VMSize "Standard_b1s" -AvailabilitySetId $myVmAvailabilitySet.Id
$myVmConfigLinux = Add-AzureRmVMNetworkInterface -VM $myVmConfigLinux -Id $myLinuxNic.Id
$myVmConfigLinux = Set-AzureRmVMOperatingSystem -VM $myVmConfigLinux -Linux -ComputerName mylinuxvm7475 -Credential $myCredLinux
$myVmConfigLinux = Set-AzureRmVMSourceImage -VM $myVmConfigLinux -PublisherName Canonical -Offer UbuntuServer -Skus 16.04.0-LTS -Version "16.04.201802220"
$myVmConfigLinux = Set-AzureRmVMOSDisk -VM $myVmConfigLinux -Name "myVmLinuxOSDisk7475" -Caching ReadWrite -Linux -CreateOption FromImage -DiskSizeInGB 127  -StorageAccountType Standard_LRS 
$myVmConfigLinux = Add-AzureRmVMSshPublicKey -VM $myVmConfigLinux -KeyData $myLinuxKeyData -Path "/home/rajesh/.ssh/authorized_keys"
$myVmConfigLinux = Set-AzureRmVMBootDiagnostics -VM $myVmConfigLinux -Enable -ResourceGroupName TestResourceGroup -StorageAccountName $myStorageAccount.StorageAccountName 

$myVmConfigLinux.OSProfile.LinuxConfiguration

New-AzureRmVm -ResourceGroupName TestRG -Location 'East US 2' -VM $myVmConfigLinux

$myLinuxVm = Get-AzureRmVm -ResourceGroupName TestRG -Name myLinuxVM7475 

$myLogAnalyticsWorkSpace = Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName RecoveryRG -Name myLogAnalytics7476
Set-AzureRmDiagnosticSetting -ResourceId $myLinuxVm.Id -Name myDSVMLinux7475 -WorkspaceId $myLogAnalyticsWorkSpace.ResourceId -Enabled $true 


$myLinuxVm = Get-AzureRmVm -ResourceGroupName TestRG -Name mylinuxvm7475
$myAutomationAccount = Get-AzureRmAutomationAccount -ResourceGroupName TestResourceGroup -Name myAutomationAccount7475 
$myAutomationScheduleLinux = New-AzureRmAutomationSchedule -Name myLinuxUpdateSchedule -StartTime 13:30 -Description "Software update Schedule" -OneTime -ResourceGroupName TestResourceGroup -TimeZone "India Standard Time" -ForUpdateConfiguration -AutomationAccountName $myAutomationAccount.AutomationAccountName 
New-AzureRmAutomationSoftwareUpdateConfiguration -ResourceGroupName TestResourceGroup -Schedule $myAutomationScheduleLinux -Linux -AzureVMResourceId $myLinuxVm.Id -Duration 180 -AutomationAccountName $myAutomationAccount.AutomationAccountName -RebootSetting IfRequired 

$myLogAnalyticsWorkSpace = Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName RecoveryRG -Name myLogAnalytics7476

# Activate an OMS solution (in this case - Change Tracking) in the workspace
Set-AzureRmOperationalInsightsIntelligencePack -ResourceGroupName RecoveryRG -WorkspaceName $myLogAnalyticsWorkSpace.Name -IntelligencePackName "ChangeTracking" -Enabled $true

# Create references to the WorkspaceId and WorkspaceKey
$myLogAnalyticsWorkSpaceId = $myLogAnalyticsWorkSpace.CustomerId
$myLogAnalyticsWorkSpaceKey = (Get-AzureRmOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $myLogAnalyticsWorkSpace.ResourceGroupName -Name $myLogAnalyticsWorkSpace.Name).PrimarySharedKey
Set-AzureRmVMExtension -ResourceGroupName TestRG -VMName mylinuxvm7475 -Name 'OmsAgentForLinux' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'OmsAgentForLinux' -TypeHandlerVersion '1.0' -Location EastUs2 -SettingString "{'workspaceId': '$myLogAnalyticsWorkSpaceId'}" -ProtectedSettingString "{'workspaceKey': '$myLogAnalyticsWorkSpaceKey'}"



############################End Creating Linux Vm ##########################################################
}

} ## End Parallel 
Start-Sleep -Seconds 180
Get-AzureRmVMExtension -ResourceGroupName TestRG -VMName myVMWin7475 | select VmName, Name, ProvisioningState, Statuses, SubStatuses 
Get-AzureRmVMExtension -ResourceGroupName TestRG -VMName myLinuxVM7475 | select VmName, Name, ProvisioningState, Statuses, SubStatuses 
Get-AzureRmPublicIpAddress | Select name, IPAddress, Location

#### End of script ####


} ## End WorkFlow 

