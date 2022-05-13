locals {
    # instance_ami = "ami-0022f774911c1d690"
    instance_ami_flash = 	"ami-0dbbb837b1373416b"
    subnet_ids   = data.aws_ssm_parameters_by_path.smm_vpc_subnets.values
}





resource "aws_launch_template" "website_lt" {
  name = "website_launch_template"

  image_id = local.instance_ami_flash

  instance_type = "t2.micro"

  # key_name = "upbKeyPair"

   #user_data = data.template_file.user_data_ins.rendered
  
  user_data = "${base64encode(<<EOT
  #!/usr/bin/env bash 
  export PORT =${var.db_port}
  export DB =${var.db_name} 
  export DB_HOST =${var.db_hostname}  
  export DB_USER =${var.db_user}  
  export DB_PASS =${var.db_pass} 
  EOT
  )}"

 network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.smm_instance_sg_lb.id]
  }

#   vpc_security_group_ids = 

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "asg-instance"
    }
  }
}

resource "aws_autoscaling_group" "website_asg" {
  vpc_zone_identifier = local.subnet_ids
  desired_capacity   = 2
  max_size           = 2
  min_size           = 1
  
  # target_group_arns  = [
  #   aws_lb_target_group.website_tg.arn
  # ]

  launch_template {
    id      = aws_launch_template.website_lt.id
    version = "$Latest"
  }
}

resource "aws_lb_target_group" "website_tg" {
  name        = "website-tg"
  port     = 3306
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id_parameter.value
}

resource "aws_security_group" "upb_load_balancer_sg" {
  name        = "upb-load-balancer-sg"
  vpc_id      = data.aws_ssm_parameter.vpc_id_parameter.value

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
    Name = "upb-load-balancer-sg"
  }
}

resource "aws_security_group" "smm_instance_sg_lb" {
  name        = "upb-instance-sg-lb"
  vpc_id      = data.aws_ssm_parameter.vpc_id_parameter.value

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

resource "aws_lb" "upb_alb" {
  name               = "upb-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.upb_load_balancer_sg.id]
  subnets            = local.subnet_ids

}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.website_asg.id
  lb_target_group_arn    = aws_lb_target_group.website_tg.arn
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.upb_alb.arn
  port              = "3306"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.website_tg.arn
  }
}