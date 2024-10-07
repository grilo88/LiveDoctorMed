# resource "aws_ami_from_instance" "custom_ami" {
#   name                = "my-custom-ami"
#   description         = "My custom AMI created with Terraform"
#   source_instance_id  = aws_instance.ec2_instance.id

#   tags = {
#     Name = "MyCustomAMI"
#   }
# }
