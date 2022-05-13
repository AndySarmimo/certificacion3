locals {
  
    instance_ami_flash = 	"ami-09b846c092338654e"
    subnet_ids   = data.aws_ssm_parameters_by_path.smm_vpc_subnets.values
}





# resource "aws_launch_template" "website_lt" {
#   name = "website_launch_template"

#   image_id = local.instance_ami_flash

#   instance_type = "t2.micro"

#   # key_name = "upbKeyPair"

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups = [aws_security_group.smm_instance_sg_lb.id]
#   }

# #   vpc_security_group_ids = 

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = "asg-instance"
#     }
#   }

#   user_data = "${data.template_file.user_data_ins.rendered}"
# }





resource "aws_security_group" "smm_instance_sg_lb" {
  name        = "upb-instance-sg-lb"
  //vpc_id      = data.aws_ssm_parameter.vpc_id_parameter.value

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  # ingress {
  #   description      = "http traffic"
  #   from_port        = 80
  #   to_port          = 80
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 
  tags = {
    Name = "smm-instance-sg-lb"
  }
}

# resource "aws_network_interface" "foo2" {
#   subnet_id   = "subnet-01c1a71e8a82275de"
#   # private_ips = ["172.16.10.100"]

#   tags = {
#     Name = "primary_network_interface"
#   }
# }


resource "aws_instance" "ins_prueba" {
  
  ami=local.instance_ami_flash
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.smm_instance_sg_lb.id]
 
  user_data = "${data.template_file.user_data_ins.rendered}"
  
  # launch_template{
  # #     id=aws_launch_template.website_lt.id
  # # }
  
 
}