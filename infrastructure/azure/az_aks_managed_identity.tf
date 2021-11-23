resource "azurerm_user_assigned_identity" "aks_mid" {
  depends_on = [
    azurerm_resource_group.main,
  ]

  count               = var.azure_aks_spn_create ? 1 : 0
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = var.azure_aks_spn_name
}

data "azurerm_user_assigned_identity" "aks_mid" {
  count               = var.azure_aks_spn_create ? 0 : 1
  name                = var.azure_aks_spn_name
  resource_group_name = var.azure_aks_spn_rg
}
