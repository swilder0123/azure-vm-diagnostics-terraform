# azure-vm-diagnostics-terraform
Create Azure Diagnostics VM configuration in Terraform

This is a project to allow Azure VM diagnostics to be configured via Terraform. By default, it will cconfigure an Eventhub sink for all security events.

## Limitations
This configuration is only enabled for WADCFG (Windows). LADCFG (Linux) is somewhat simpler and could follow.

Currently, it is required to modify the WADCFG settings 'heredoc' section in order to change the logging payload. 

The integration will fail if IaaSDiagnostics is currently deployed on the target VM. Use the Azure CLI or the portal to remove the IaaSDiagnostics extension

The existing diagnostics configuration will be wiped by deleting and configuring the extension via this method.

Notice: Any change to the diagnostics configuration from the Azure portal will wipe the automated configuration and it will be necessary to reapply the desired changes
