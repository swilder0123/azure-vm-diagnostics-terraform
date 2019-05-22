locals {
	eventhub_url = "https://${azurerm_eventhub_namespace.hub.name}.servicebus.windows.net/${azurerm_eventhub.hub.name}"
}

resource "azurerm_resource_group" "diag" {
	name      = "${var.vm_resource_group_name}"
	location  = "${var.azure_location_name}"
}

resource "azurerm_virtual_machine_extension" "diag" {
  depends_on           = ["data.azurerm_storage_account_sas.store"]
  name                 = "IaaSDiagnostics"
  location             = "${azurerm_resource_group.diag.location}"
  resource_group_name  = "${azurerm_resource_group.diag.name}"
  virtual_machine_name = "${var.virtual_machine_name}"
  publisher            = "Microsoft.Azure.Diagnostics"
  type                 = "IaasDiagnostics"
  type_handler_version = "1.9"

  settings=<<SETTINGS
  {
      "WadCfg": {
          "DiagnosticMonitorConfiguration": {
              "DiagnosticInfrastructureLogs": {
                  "scheduledTransferLogLevelFilter": "Warning"
              },
              "WindowsEventLog": {
                  "DataSource": [
                      {
                          "name": "Security!*"
                      }
                  ],
                  "scheduledTransferPeriod": "PT5M",
                  "sinks": "HotPath"
              },
              "overallQuotaInMB": "4096"
          },
          "SinksConfig": {
              "Sink": [
                  {
                      "name": "HotPath",
                      "EventHub": {
                          "Url": "${local.eventhub_url}",
                          "SharedAccessKeyName": "${azurerm_eventhub_authorization_rule.hub.name}",
                          "usePublisherId": false
                      }
                  }
              ]
          }
      },
      "storageAccount": {
          "storageAccountName": "${data.azurerm_storage_account.store.name}"
      }
  }
SETTINGS

  protected_settings=<<SETTINGS
  {
     "storageAccountName": "${data.azurerm_storage_account.store.name}",
     "storageAccountSasToken": "${data.azurerm_storage_account_sas.store.sas}",
     "EventHub": {
       "Url": "${local.eventhub_url}",
       "SharedAccessKeyName": "${azurerm_eventhub_authorization_rule.hub.name}",
       "SharedAccessKey": "${azurerm_eventhub_authorization_rule.hub.primary_key}"
     }
  }
SETTINGS

  tags = {
    environment = "Production"
  }
}
