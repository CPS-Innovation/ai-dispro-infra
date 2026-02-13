subscription = "prod"
location     = "ukwest"

vnet_address_space = ["10.7.195.0/24"]
subnets = [
  {
    name             = "snet-prod-01"
    address_prefixes = ["10.7.195.0/28"]
  },
  {
    name             = "snet-psql-prd-01"
    address_prefixes = ["10.7.195.16/28"]
  },
  {
    name             = "snet-asp-shrd-vnetint-prod-01"
    address_prefixes = ["10.7.195.32/28"]
    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  },
  {
    name             = "snet-pe-prd-01"
    address_prefixes = ["10.7.195.48/28"]
  }
]