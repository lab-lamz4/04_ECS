module "alb" {
  source      = "../../modules/alb"
  name        = "app-load-balancer-ecs"
  environment = "learning"

  # Create a new ALB
  enable_alb                     = true
  alb_load_balancer_type         = "application"
  alb_name                       = "alb-ecs"
  alb_security_groups            = [module.sg.security_group_id]
  alb_subnets                    = module.vpc.public_subnets_ids
  alb_internal                   = false
  alb_enable_deletion_protection = false
  alb_target_group_target_type   = "ip"

  # Create ALB target group
  enable_alb_target_group   = true
  alb_target_group_name     = "alb-ecs-tg"
  alb_target_group_protocol = "HTTP"
  alb_target_group_vpc_id   = module.vpc.vpc_id

  alb_target_group_health_check = [
    {
      enabled             = true
      port                = 80
      protocol            = "HTTP"
      interval            = 10
      path                = "/"
      healthy_threshold   = 3
      unhealthy_threshold = 3
      timeout             = 5
      matcher             = "200-299"
    }
  ]

  # Create ALB target group attachment
  enable_alb_target_group_attachment     = false

  # Create ALB listener
  enable_alb_listener              = true
  alb_listener_port                = 80
  alb_listener_protocol            = "HTTP"
  alb_listener_default_action_type = "forward"

  # listener rule rule
  enable_alb_listener_rule      = false

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ecs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

  depends_on = [
    module.vpc,
    module.sg
  ]

}
