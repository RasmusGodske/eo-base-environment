resource "azurerm_storage_account" "example" {
  depends_on = [
    azurerm_resource_group.main,
  ]
  name                     = "xxshdinsightstor"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "xxshdinsight"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_network_security_rule" "https_inbound" {
  depends_on = [
    azurerm_resource_group.main,
    module.nsg,
    module.public_ip
  ]

  name                   = "https_inbound"
  priority               = 100
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "443"
  source_address_prefix  = "*"
  destination_address_prefixes = [
    "52.164.210.96",
    "13.74.153.132"
  ]
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = module.nsg.name
}

resource "azurerm_network_security_rule" "rest_proxy_inbound" {
  depends_on = [
    azurerm_resource_group.main,
    module.nsg,
    module.public_ip
  ]

  name                        = "rest_proxy_inbound"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = module.nsg.name
}

# resource "azurerm_network_security_rule" "rest_proxy_outbound" {
#   depends_on = [
#     azurerm_resource_group.main,
#     module.nsg,
#     module.public_ip
#   ]

#   name                        = "rest_proxy_outbound"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.main.name
#   network_security_group_name = module.nsg.name
# }

module "azurerm_hdinsight_kafka_cluster" {
  depends_on = [
    azurerm_resource_group.main,
    module.network,
    azurerm_storage_account.example,
    azurerm_storage_container.example,
    azurerm_network_security_rule.https_inbound,

  ]
  source = "./hdinsigts-kafka-cluster"

  name                 = var.project_name
  environment_short    = var.environment_short
  environment_instance = var.environment_instance
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  tier                 = "Standard"
  cluster_version      = "4.0"

  gateway = {
    username = "acctestusrgw"
    password = "TerrAform123!"
  }



  storage_account = {
    storage_container_id = azurerm_storage_container.example.id
    storage_account_key  = azurerm_storage_account.example.primary_access_key
    is_default           = true
  }

  head_node = {
    vm_size            = "Standard_D3_V2"
    username           = "acctestusrvm"
    password           = "AccTestvdSC4daf986"
    virtual_network_id = module.network.id
    subnet_id          = module.network.subnets.cluster_network.id
  }

  worker_node = {
    vm_size                  = "Standard_D3_V2"
    username                 = "acctestusrvm"
    password                 = "AccTestvdSC4daf986"
    number_of_disks_per_node = 1
    target_instance_count    = 3
    virtual_network_id       = module.network.id
    subnet_id                = module.network.subnets.cluster_network.id
  }

  zookeeper_node = {
    vm_size            = "Standard_D3_V2"
    username           = "acctestusrvm"
    password           = "AccTestvdSC4daf986"
    virtual_network_id = module.network.id
    subnet_id          = module.network.subnets.cluster_network.id
  }
}
