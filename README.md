# conditional-user-access-admin

Reusable Terraform module that grants conditional User Access Administrator
(or another delegation role) at a scope and restricts which roles the delegate
can assign/remove.

## Inputs

- `scope` - Azure scope for the delegated assignment
- `principal_id` - object ID of the delegating principal
- `uaa_role_definition_name` - default `User Access Administrator`
- `allowed_role_definition_ids` - allowlist of assignable/removable role GUIDs
- `allowed_principal_types` - allowed principal types, default `["Group"]`
- `allowed_principal_ids` - optional allowlist of principal object IDs
- `description` - optional description

## Notes

- This is permanent constrained delegation, not JIT.
- Restrict to groups wherever possible.
- Assign at the smallest possible scope.
- Prefer approved groups over arbitrary principals.


## Example usage

module "dev_sp_conditional_uaa" {  
  source = "../../modules/uaa"  

  scope                = azurerm_resource_group.app.id  
  principal_id         = "xxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx"  
  role_definition_name = "User Access Administrator"  


  allowed_role_definition_ids = [  
  "acdd72a7-3385-48ef-bd42-f606fba81ae7", # Reader  
  "4633458b-17de-408a-b874-0445c86b69e6", # Key Vault Secrets User  
  "b86a8fe4-44ce-4948-aee5-eccb2c155cd7", # Key Vault Secrets Officer  
  "21090545-7ca7-4776-b22c-e363652d74d2", # Key Vault Reader  
  "2a2b9908-6ea1-4ae2-8e65-a410df84e7d1", # Storage Blob Data Reader  
  "ba92f5b4-2d11-453d-a403-e96b0029c9fe", # Storage Blob Data Contributor  
  ]  

  allowed_principal_types = ["Group", "ServicePrincipal"]  

}
