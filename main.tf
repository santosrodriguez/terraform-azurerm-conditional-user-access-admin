locals {
  role_ids_csv = join(", ", var.allowed_role_definition_ids)

  principal_types_csv = join(
    ", ",
    [for t in var.allowed_principal_types : "'${t}'"]
  )

  principal_ids_csv = join(", ", var.allowed_principal_ids)

  write_condition_base = <<-EOT
@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.role_ids_csv}}
AND
@Request[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {${local.principal_types_csv}}
EOT

  delete_condition_base = <<-EOT
@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.role_ids_csv}}
AND
@Resource[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {${local.principal_types_csv}}
EOT

  write_condition_with_principals = length(var.allowed_principal_ids) > 0 ? join("\n", [
    local.write_condition_base,
    "AND",
    "@Request[Microsoft.Authorization/roleAssignments:PrincipalId] ForAnyOfAnyValues:GuidEquals {${local.principal_ids_csv}}"
  ]) : local.write_condition_base

  delete_condition_with_principals = length(var.allowed_principal_ids) > 0 ? join("\n", [
    local.delete_condition_base,
    "AND",
    "@Resource[Microsoft.Authorization/roleAssignments:PrincipalId] ForAnyOfAnyValues:GuidEquals {${local.principal_ids_csv}}"
  ]) : local.delete_condition_base

  condition = <<-EOT
(
  (
    !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
  )
  OR
  (
    ${local.write_condition_with_principals}
  )
)
AND
(
  (
    !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
  )
  OR
  (
    ${local.delete_condition_with_principals}
  )
)
EOT
}

resource "azurerm_role_assignment" "conditional_uaa" {
  scope                = var.scope
  principal_id         = var.principal_id
  role_definition_name = var.role_definition_name

  condition_version = "2.0"
  condition         = local.condition

  description = var.description
}
