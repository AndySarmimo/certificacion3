
data "aws_ssm_parameter" "db_id_parameter" { # data.aws_ssm_parameter.vpc_id_parameter.value
  name ="/flashcards/db/id"
}

