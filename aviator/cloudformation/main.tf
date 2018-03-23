resource "aws_cloudformation_stack" "MyCloudFormationStack" {
  name = "MyCloudFormationStack"

  parameters {
    KeyName = "${var.key_name}"
  }

  template_body = "${file("${path.module}/example.template")}"
  capabilities  = ["CAPABILITY_IAM"]

  tags {
    Backup = "${var.tag_foo}"
  }
}
