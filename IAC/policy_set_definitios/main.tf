resource "azurerm_policy_set_definition" "policy_set_landingZone" {
  for_each = { for f in local.json_policyset_data : f.name => f }

  # Mandatory resource attributes
  name         = each.value.name
  policy_type  = "Custom"
  display_name = each.value.properties.displayName

  # Dynamic configuration blocks
  dynamic "policy_definition_reference" {
    for_each = [
      for item in each.value.properties.policyDefinitions :
      {
        policyDefinitionId          = item.policyDefinitionId
        parameters                  = try(jsonencode(item.parameters), null)
        policyDefinitionReferenceId = try(item.policyDefinitionReferenceId, null)
      }
    ]
    content {
      policy_definition_id = replace(policy_definition_reference.value["policyDefinitionId"], "d8264cd1-427d-8885-8d47-3aa0b35c80e7", "${var.management_group_id}")

      parameter_values = policy_definition_reference.value["parameters"]
      reference_id     = policy_definition_reference.value["policyDefinitionReferenceId"]
    }
  }

  # Optional resource attributes
  description         = try(each.value.properties.description, "${each.value.properties.displayName} Policy Set Definition at scope ${var.management_group_id}")
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  metadata            = try(length(each.value.properties.metadata) > 0, false) ? jsonencode(each.value.properties.metadata) : null
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

  identity {
    type = try(length(each.value.identity.type) > 0, false) ? each.value.identity.type : null
  }
  depends_on = [
    azurerm_policy_set_definition.policy_set_landingZone
  ]
}
