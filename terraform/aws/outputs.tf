output "script" {
  value = local.script
}

output "script-gitlab" {
  value     = local.script-gitlab
  sensitive = true
}
