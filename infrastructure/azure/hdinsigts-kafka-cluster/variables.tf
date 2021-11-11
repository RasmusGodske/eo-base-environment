variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Kubernetes cluster. Changing this forces a new resource to be created."
}

variable "environment_short" {
  type        = string
  description = "(Required) The short value name of your environment."
}

variable "environment_instance" {
  type        = string
  description = "(Required) The instance value of your environment."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the AKS cluster. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "tier" {
  type        = string
  description = "(Required) Specifies the Tier which should be used for this HDInsight Kafka Cluster. Possible values are Standard or Premium. Changing this forces a new resource to be created."
}

variable "cluster_version" {
  type        = string
  description = "(Required) Specifies the Version of HDInsights which should be used for this Cluster. Changing this forces a new resource to be created."
}

variable "gateway" {
  type = object({
    username = string
    password = string
  })
  description = "(Required) TODO: Add description"
}

variable "head_node" {
  type = object({
    vm_size            = string
    username           = string
    password           = string
    subnet_id          = string
    virtual_network_id = string
  })
  default = {
    vm_size                  = null
    username                 = null
    password                 = null
    ssh_keys                 = []
    virtual_network_id       = null
    subnet_id                = null
  }
  description = "(Required) TODO: Add description"
}

variable "worker_node" {
  type = object({
    number_of_disks_per_node = number
    vm_size                  = string
    username                 = string
    password                 = string
    subnet_id                = string
    target_instance_count    = number
    virtual_network_id       = string
  })
  default = {
    number_of_disks_per_node = 1
    vm_size                  = null
    username                 = null
    password                 = null
    virtual_network_id       = null
    subnet_id                = null
    target_instance_count    = 1
    virtual_network_id       = 3
  }
  description = "(Required) TODO: Add description"
}

variable "zookeeper_node" {
  type = object({
    vm_size            = string
    username           = string
    password           = string
    subnet_id          = string
    virtual_network_id = string
  })
  default = {
    vm_size            = null
    username           = null
    password           = null
    virtual_network_id = null
    subnet_id          = null
  }
  description = "(Required) TODO: Add description"
}


variable "storage_account" {
  type = object({
    storage_container_id = string
    storage_account_key  = string
    is_default           = bool
  })
  description = " (Required) One or more storage_account block as defined below."
}
