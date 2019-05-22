# azure-vm-diagnostics-terraform
Create Azure Diagnostics VM configuration in Terraform

This is a project to allow Azure VM diagnostics to be configured via Terraform. By default, it will configure event flows to an Eventhub sink for all security events. This is meant to support SIEM ingest workflows from Azure VMs.

This project makes no attempt to create or configure the Event Hub. Create an Azure Event Hub using the Standard SKU and the default configuration.
## How to use this project
You will need to have an active Azure subscription in order to use Event Hubs. In addition, the diagnostics configuration is only applicable to (Windows) virtual machines.
In addition to copying/cloning the repo, you must take these steps:
- Create an Event Hub you can access (or use an existing one). A Standard SKU is recommended. You will need administrator access to configure the event hub, but you can use pre-configured authorization rules if you have appropriate key(s).
- You will need to initialize Terraform in the working directory for your project. You can run this from the Azure Shell if you have access (https://shell.azure.com).
- You will need at least 'contributor' access to the target VM to add and remove VMExtensions. This project was tested with 'administrator' access.
- Recommended: Use Azure Resource Explorer (https://resources.azure.com) to inspect the configuration of the target VM. Make sure that the extension shows "provisioningState": "Succeeded"
## Limitations
This configuration is only enabled for WADCFG (Windows). LADCFG (Linux) is somewhat simpler and could follow.

Currently, it is required to modify the WADCFG settings 'heredoc' section in order to change the logging payload. 

The integration will fail if IaaSDiagnostics is currently deployed on the target VM. Use the Azure CLI or the portal to remove the IaaSDiagnostics extension

The existing diagnostics configuration will be wiped by deleting and configuring the extension via this method.

Notice: Any change to the diagnostics configuration from the Azure portal will wipe the automated configuration and it will be necessary to reapply the desired changes
