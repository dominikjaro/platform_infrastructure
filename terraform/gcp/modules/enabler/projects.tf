# Create projects

resource "google_project" "projects" {
  for_each = local.projects

  project_id      = each.value.project_id
  name            = each.value.name
  billing_account = lookup(each.value, "billing_account", null)
}
