
locals{
  snapshot_db_arn= "arn:aws:rds:us-east-1:271878697119:snapshot:flashsnapshotv2"
}

resource "aws_security_group" "db_sg" {
  name        = "smm-instance-sg-db"
  vpc_id      = data.aws_ssm_parameter.vpc_id_parameter.value

  ingress {
    description      = "all traffic"
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
    Name = "smm-instance-sg"
  }
}

resource "aws_db_subnet_group" "db_sub" {
  name       = "smm_subnet_group_db"
  # subnet_ids = [ data.aws_ssm_parameter.subnet_id_weA.value, data.aws_ssm_parameter.subnet_id_weB.value,data.aws_ssm_parameter.subnet_id_weC.value]
  subnet_ids = data.aws_ssm_parameters_by_path.smm_vpc_subnets.values
  tags = {
    Name = "My DB subnet group"
  }
}

# resource "random_password" "db_master_pass" {
#   length            = 10
#   special           = true
#   min_special       = 2
#   override_special  = "!#$%^&*()-_=+[]{}<>:?"
#   keepers           = {
#     pass_version  = 1
#   }
# }



resource "aws_db_instance" "flashDB" {
 identifier           =  "my-flash-db" 
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  port = 3306
  # vpc_id      = data.aws_ssm_parameter.vpc_id_parameter.value
  db_subnet_group_name = aws_db_subnet_group.db_sub.name
  db_name                 = "myFlashDB"
  username             = "root"
  # password             = random_password.db_master_pass.result
  password             = "rootroot"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible = true
  snapshot_identifier = local.snapshot_db_arn
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  skip_final_snapshot  = true
  
  lifecycle{
    ignore_changes=[snapshot_identifier]
  }
}



resource "aws_ssm_parameter" "db_id" {
  name  = "/flashcards/db/id"
  type  = "String"
  value = aws_db_instance.flashDB.id
}
