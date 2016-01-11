variable "name" {}
variable "id" {}
variable "type" {
  default = "client"
}
variable "rules" {
  default = ""
}

variable "token" {}
variable "user" {
  default = "ubnutu"
}
variable "host" {}

variable "private_key" {}
variable "bastion_host" {}
variable "bastion_user" {}
variable "bastion_private_key" {}

resource "template_file" "acl" {
  template = "${file(concat(path.module), "/acl.json.tpl")}"

  vars = {
    id    = "${var.id}"
    name  = "${var.name}"
    type  = "${var.type}"
    rules = "${var.rules}"
  }
}

resource "null_resource" "acl" {
  connection {
    user         = "${var.user}"
    host         = "${var.host}"
    private_key  = "${var.private_key}"
    bastion_host = "${var.bastion_host}"
    bastion_user = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }

  provisioner "remote-exec" {
    inline = [
    "curl -X PUT -d '${template_file.acl.rendered}' http://localhost:8500/v1/acl/create?token=${var.token}"
    ]
  }
}

output "token" {
  value = "${var.id}"
}
output "type" {
  value = "${var.type}"
}
output "name" {
  value = "${var.name}"
}
output "rules" {
  value = "${var.rules}"
}
