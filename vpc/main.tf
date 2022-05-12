locals {
  subnets = {
    "sn-reserved-A"= {
      cidr_block="10.16.0.0/20"
      az="us-east-1a"
      type = "reserved"
    }
    "sn-db-A"= {
      cidr_block="10.16.16.0/20"
      az="us-east-1a"
      type = "db"
    }
    "sn-app-A"= {
      cidr_block="10.16.32.0/20"
      az="us-east-1a"
      type = "app"
    }
    "sn-web-A"= {
      cidr_block="10.16.48.0/20"
      az="us-east-1a"
      type = "web"
    }
    "sn-reserved-B"= {
      cidr_block="10.16.64.0/20"
      az="us-east-1b"
      type = "reserved"
    }
    "sn-db-B"= {
      cidr_block="10.16.80.0/20"
      az="us-east-1b"
      type = "db"
    }
    "sn-app-B"= {
      cidr_block="10.16.96.0/20"
      az="us-east-1b"
      type = "app"
    }
    "sn-web-B"= {
      cidr_block="10.16.112.0/20"
      az="us-east-1b"
      type = "web"
    }
    "sn-reserved-C"= {
      cidr_block="10.16.128.0/20"
      az="us-east-1c"
      type = "reserved"
    }
    "sn-db-C"= {
      cidr_block="10.16.144.0/20"
      az="us-east-1c"
      type = "db"
    }
    "sn-app-C"= {
      cidr_block="10.16.160.0/20"
      az="us-east-1c"
      type = "app"
    }
    "sn-web-C"= {
      cidr_block="10.16.176.0/20"
      az="us-east-1c"
      type = "web"
    }
  }
}



resource "aws_vpc" "smm_vpc" { # aws_vpc.upb_vpc.id
  cidr_block = "10.16.0.0/16"
  assign_generated_ipv6_cidr_block=true
  enable_dns_hostnames=true
  tags = {
      Name="smm_vpc"
  }
}
resource "aws_subnet" "smm_subnets" { 
  for_each   = local.subnets
  vpc_id     = aws_vpc.smm_vpc.id
  cidr_block = each.value.cidr_block
  availability_zone= each.value.az

  tags = {
    Name = each.key
    Type = each.value.type
  }
}

resource "aws_internet_gateway" "smm_igw" {
  vpc_id = aws_vpc.smm_vpc.id

  tags = {
    Name = "smm-igw"
  }
}

resource "aws_route_table" "smm_rt" {
  vpc_id = aws_vpc.smm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.smm_igw.id
  }

  tags = {
    Name = "smm-web-rt"
  }
}
resource "aws_route_table_association" "smm_rt_association" {
  for_each = {
    "sn-web-A" = local.subnets.sn-web-A
    "sn-web-B" = local.subnets.sn-web-B
    "sn-web-C" = local.subnets.sn-web-C
  }
  subnet_id      = aws_subnet.smm_subnets["${each.key}"].id
  route_table_id = aws_route_table.smm_rt.id
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/flashcards/vpc/id"
  type  = "String"
  value = aws_vpc.smm_vpc.id
}


resource "aws_ssm_parameter" "smm_vpc_subnet" {
  for_each = aws_subnet.smm_subnets
  name  = "/flashcards/vpc/subnets/${each.value.tags_all.Type}/${each.value.id}"
  type  = "String"
  value = each.value.id
}


# resource "aws_ssm_parameter" "subnet_web_a" {
#   name  = "/flashcards/vpc/subnetA/id"
#   type  = "String"
#   value = aws_subnet.smm_subnets["sn-web-A"].id
# }

# resource "aws_ssm_parameter" "subnet_web_b" {
#   name  = "/flashcards/vpc/subnetB/id"
#   type  = "String"
#   value =  aws_subnet.smm_subnets["sn-web-B"].id
# }

# resource "aws_ssm_parameter" "subnet_web_c" {
#   name  = "/flashcards/vpc/subnetC/id"
#   type  = "String"
#   value =  aws_subnet.smm_subnets["sn-web-C"].id
# }

