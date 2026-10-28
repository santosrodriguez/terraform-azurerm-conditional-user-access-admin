variable "scope" {
  description = "The Azure resource scope where the delegated UAA assignment will be created."
  type        = string
}

variable "principal_id" {
  description = "Object ID of the delegating principal that will receive conditional User Access Administrator. This can be a service principal, managed identity, user, or group object ID."
  type        = string
}

variable "uaa_role_definition_name" {
  description = "Azure RBAC role used for delegation. Default is User Access Administrator."
  type        = string
  default     = "User Access Administrator"
}

variable "allowed_role_definition_ids" {
  description = <<EOF
List of Azure role definition GUIDs that the delegated principal is allowed to assign/remove.
Example:
[
  "acdd72a7-3385-48ef-bd42-f606fba81ae7", # Reader
  "b24988ac-6180-42a0-ab88-20f7382dd24c"  # Contributor
]
EOF
  type = list(string)

  validation {
    condition     = length(var.allowed_role_definition_ids) > 0
    error_message = "allowed_role_definition_ids must contain at least one Azure role definition GUID."
  }
}

variable "allowed_principal_types" {
  description = "Principal types the delegated principal may assign roles to. Valid Azure RBAC values typically include User, Group, and ServicePrincipal."
  type        = list(string)
  default     = ["Group"]
}

variable "allowed_principal_ids" {
  description = "Optional list of specific Entra object IDs that the delegated principal may assign roles to. Leave empty to allow any principal matching allowed_principal_types."
  type        = list(string)
  default     = []
}

variable "description" {
  description = "Optional description tag for module consumers."
  type        = string
  default     = null
}

variable "role_definition_name" {
  type = string
}
