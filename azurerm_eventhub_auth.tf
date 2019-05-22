resource "azurerm_resource_group" "hub" {
  name     = "${var.eventhub_resource_group_name}"
  location = "${var.azure_location_name}"
}

resource "azurerm_eventhub_namespace" "hub" {
  name                = "${var.eventhub_namespace_name}"
  location            = "${azurerm_resource_group.hub.location}"
  resource_group_name = "${azurerm_resource_group.hub.name}"
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "hub" {
  name                = "${var.eventhub_entity_name}"
  namespace_name      = "${azurerm_eventhub_namespace.hub.name}"
  resource_group_name = "${azurerm_resource_group.hub.name}"
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "hub" {
  name                = "${var.eventhub_authorization_rule_name}"
  namespace_name      = "${azurerm_eventhub_namespace.hub.name}"
  eventhub_name       = "${azurerm_eventhub.hub.name}"
  resource_group_name = "${azurerm_resource_group.hub.name}"
  listen              = false
  send                = true
  manage              = false
}
