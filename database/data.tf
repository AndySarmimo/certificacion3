data "aws_ssm_parameter" "vpc_id_parameter" { # data.aws_ssm_parameter.vpc_id_parameter.value
  name = "/flashcards/vpc/id"
}




# data "aws_ssm_parameter" "subnet_id_weA" { # data.aws_ssm_parameter.vpc_id_parameter.value
#   name =  "/flashcards/vpc/subnetA/id"
# }

# data "aws_ssm_parameter" "subnet_id_weB" { # data.aws_ssm_parameter.vpc_id_parameter.value
#   name =  "/flashcards/vpc/subnetB/id"
# }

# data "aws_ssm_parameter" "subnet_id_weC" { # data.aws_ssm_parameter.vpc_id_parameter.value
#   name =  "/flashcards/vpc/subnetC/id"
# }


data "aws_ssm_parameters_by_path" "smm_vpc_subnets" {
  path = "/flashcards/vpc/subnets/web"
}