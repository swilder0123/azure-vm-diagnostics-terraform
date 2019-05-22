
resource "azurerm_resource_group" "store" {
  name     = "${var.storage_resource_group_name}"
  location = "${var.azure_location_name}"
}

data "azurerm_storage_account" "store" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${azurerm_resource_group.store.name}"
}

data "azurerm_storage_account_sas" "store" {
  connection_string = "${data.azurerm_storage_account.store.primary_connection_string}"
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = true
    table = true
    file  = true
  }

  start  = "2019-05-21T12:01:02Z"
  expiry = "2021-05-21T12:01:01Z"

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
  }
}
output "sas_url_query_string" {
  value = "${data.azurerm_storage_account_sas.store.sas}"
}
