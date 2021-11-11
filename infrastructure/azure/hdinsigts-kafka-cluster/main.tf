locals {
  module_tags = {
    "ModuleVersion" = "1.0.0",
    "ModuleId"      = "hdinsigt-kubernetes-cluster"
  }
}


resource "azurerm_hdinsight_kafka_cluster" "this" {
  name                = "hdikafka-${var.name}-${var.environment_short}-${var.environment_instance}"
  location            = var.location
  resource_group_name = var.resource_group_name
  cluster_version     = var.cluster_version
  tier                = var.tier

  component_version {
    kafka = "2.1"
  }

  gateway {
    username = var.gateway.username
    password = var.gateway.password
  }

  rest_proxy {
    security_group_id = "cb5df297-10e3-4475-b546-6f9d54ce842b"
  }

  storage_account {
    storage_container_id = var.storage_account.storage_container_id
    storage_account_key  = var.storage_account.storage_account_key
    is_default           = var.storage_account.is_default
  }

  roles {
    head_node {
      vm_size            = var.head_node.vm_size
      username           = var.head_node.username
      password           = var.head_node.password
      virtual_network_id = var.head_node.virtual_network_id
      subnet_id          = var.head_node.subnet_id
    }

    worker_node {
      vm_size                  = var.worker_node.vm_size
      username                 = var.worker_node.username
      password                 = var.worker_node.password
      number_of_disks_per_node = var.worker_node.number_of_disks_per_node
      subnet_id                = var.worker_node.subnet_id
      target_instance_count    = var.worker_node.target_instance_count
      virtual_network_id       = var.worker_node.virtual_network_id
    }

    zookeeper_node {
      vm_size            = var.zookeeper_node.vm_size
      username           = var.zookeeper_node.username
      password           = var.zookeeper_node.password
      subnet_id          = var.zookeeper_node.subnet_id
      virtual_network_id = var.zookeeper_node.virtual_network_id
    }

    kafka_management_node {
      vm_size            = var.zookeeper_node.vm_size
      username           = "testStest"
      password           = "testS1231test"
      subnet_id          = var.zookeeper_node.subnet_id
      virtual_network_id = var.zookeeper_node.virtual_network_id
    }
  }
}
