data "aws_ssm_parameter" "vpc_id_parameter" {
  name = "/flashcards/vpc/id"
}

data "aws_ssm_parameters_by_path" "smm_vpc_subnets" {
  path = "/flashcards/vpc/subnets/web"
}

data "template_file" "user_data_ins"{
  template= filebase64("${path.module}/user_data.sh")
  
 vars={
    DB_HOSTNAME=var.db_hostname
    DB_NAME=var.db_name
    DB_PASS=var.db_pass
    DB_USER=var.db_user
  }
  
}