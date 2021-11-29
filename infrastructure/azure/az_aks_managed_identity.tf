resource "azurerm_user_assigned_identity" "aks_mid" {
  depends_on = [
    azurerm_resource_group.main,
  ]

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = var.azure_aks_spn_name
  
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

resource "azurerm_role_assignment" "aks_mid_network_contributor" {
  depends_on = [
    azurerm_user_assigned_identity.aks_mid,
  ]

  count = assign_network_contributor ? 1 : 0

  scope                = azurerm_resource_group.main.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_mid.object_id
}
