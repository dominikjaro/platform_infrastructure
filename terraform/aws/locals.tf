locals {
  script = templatefile("${path.module}/scripts/script.tpl", {
  })
}
locals {
  script-gitlab = templatefile("${path.module}/scripts/script-gitlab.tpl", {
    runner_registration_token = var.runner_registration_token
  })
}
