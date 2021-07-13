module "sg" {
  source      = "../../modules/sg"
  name        = "epam-leodorov-ecs"
  environment = "learning"

  enable_security_group = true
  security_group_name   = "alb-ecs-sg"
  security_group_vpc_id = module.vpc.vpc_id


  security_group_ingress = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"

      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      description      = "HTTP to ALB"
      security_groups  = null
      self             = null
    }
  ]

  security_group_egress = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"

      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      description      = "all from ALB"
      security_groups  = null
      self             = null
    }
  ]

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ecs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
}

module "sg-private" {
  source      = "../../modules/sg"
  name        = "epam-leodorov-ecs"
  environment = "learning"

  enable_security_group = true
  security_group_name   = "private-sg"
  security_group_vpc_id = module.vpc.vpc_id


  security_group_ingress = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"

      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      description      = "alb to ecs"
      security_groups  = [module.sg.security_group_id]
      self             = null
    }
  ]

  security_group_egress = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"

      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      description      = "all out"
      security_groups  = null
      self             = null
    }
  ]

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ecs",
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
}