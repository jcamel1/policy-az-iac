module "policy-definitions" {
  source              = "./policy-definitions"
  management_group_id = var.management_group_id
  subscription_id     = var.subscription_id
}

module "policy_set_definitios" {
  source              = "./policy_set_definitios"
  management_group_id = var.management_group_id
  subscription_id     = var.subscription_id
  depends_on = [
    module.policy-definitions
  ]
}

