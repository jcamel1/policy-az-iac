### Crear definiciones a nivel del MG Root
resource "azurerm_policy_definition" "policy_def" {
  for_each = { for f in local.json_policy__data : f.name => f }


  # Mandatory resource attributes
  name         = each.value.name
  policy_type  = "Custom"
  mode         = each.value.properties.mode
  display_name = each.value.properties.displayName

  # Optional resource attributes
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description         = try(length(each.value.properties.description) > 0, false) ? jsonencode(each.value.properties.description) : null
  policy_rule         = try(length(each.value.properties.policyRule) > 0, false) ? jsonencode(each.value.properties.policyRule) : null
  parameters          = try(length(each.value.properties.parameters) > 0, false) ? jsonencode(each.value.properties.parameters) : null
}

### Crear asignaciones a nivel del Management Group
resource "azurerm_management_group_policy_assignment" "policy_mg_ass" {
  for_each = { for f in local.json_assignment_data : f.name => f }
  # Mandatory resource attributes
  name                 = substr(each.value.name, 1, 22)
  policy_definition_id = replace(each.value.properties.policyDefinitionId, "d8264cd1-427d-8885-8d47-3aa0b35c80e7", "${var.management_group_id}")
  management_group_id  = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  display_name         = each.value.properties.displayName

  # Optional resource attributes
  location   = try(length(each.value.location) > 0, false) ? each.value.location : null
  parameters = try(length(each.value.properties.parameters) > 0, false) ? jsonencode(each.value.properties.parameters) : null
  not_scopes = try(length(each.value.properties.notScopes) > 0, false) ? each.value.properties.notScopes : null
  depends_on = [
    azurerm_policy_definition.policy_def
  ]
}

### Crear asignaciones a nivel de la suscripcion
/* resource "azurerm_subscription_policy_assignment" "policy_sus_ass" {
  for_each = { for f in local.json_assignment_data : f.name => f  }
  # Mandatory resource attributes
  name                 = substr(each.value.name, 1, 20)
  policy_definition_id = replace(each.value.properties.policyDefinitionId, "d8264cd1-427d-8885-8d47-3aa0b35c80e7", "${var.management_group_id}")
  subscription_id      = "/subscriptions/${var.subscription_id}"
  display_name         = each.value.properties.displayName

  # Optional resource attributes
  location   = try(length(each.value.location) > 0, false) ? each.value.location : null
  parameters = try(length(each.value.properties.parameters) > 0, false) ? jsonencode(each.value.properties.parameters) : null
  not_scopes = try(length(each.value.properties.notScopes) > 0, false) ? each.value.properties.notScopes : null

}
 */
