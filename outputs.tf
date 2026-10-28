output "role_assignment_id" {
  description = "The ID of the conditional UAA role assignment."
  value       = azurerm_role_assignment.conditional_uaa.id
}

output "condition" {
  description = "The generated Azure RBAC condition applied to the assignment."
  value       = azurerm_role_assignment.conditional_uaa.condition
}

output "scope" {
  description = "The scope where the conditional UAA assignment was created."
  value       = azurerm_role_assignment.conditional_uaa.scope
}
