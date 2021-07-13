module "ecs_cluster" {
  source      = "../../modules/ecs"
  environment = "learning"

  enable_ecs_cluster = true
  ecs_cluster_name   = "learning-ecs-cluster"
  ecs_cluster_capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  ecs_cluster_default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = "80"
      base              = 1
    },
    {
      capacity_provider = "FARGATE"
      weight            = "20"
      base              = null
    }
  ]
  ecs_cluster_setting = [
    {
      name  = "containerInsights",
      value = "enabled"
    }
  ]

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ecs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
  
  depends_on = [
    module.vpc,
    module.iam_role
  ]

}

##############################################################
## ECS task definition
##############################################################
module "ecs_task_definition" {
  source      = "../../modules/ecs"
  name        = "epam-leodorov-ecs-td"
  environment = "learning"

  enable_ecs_task_definition                = true
  ecs_task_definition_family                = "epam-leodorov-ecs-td"
  ecs_task_definition_container_definitions = file("./additional_files/ecs/container_definitions.json")

  ecs_task_definition_task_role_arn      = module.iam_role.iam_role_arn
  ecs_task_definition_execution_role_arn = module.iam_role_ex.iam_role_arn
  ecs_task_definition_requires_compatibilities = ["FARGATE"]
  ecs_task_definition_network_mode        = "awsvpc"
  ecs_task_definition_cpu                 = 512
  ecs_task_definition_memory              = 1024

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ecs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

  depends_on = [
    module.vpc,
    module.iam_role_ex,
    module.iam_role
  ]
}

##############################################################
## ECS service
##############################################################
module "ecs_service" {
  source      = "../../modules/ecs"
  environment = "learning"

  enable_ecs_service = true
  ecs_service_name   = "epam-leodorov-ecs-svc"

  ecs_service_cluster         = module.ecs_cluster.ecs_cluster_id
  ecs_service_task_definition = module.ecs_task_definition.ecs_task_definition_arn
  ecs_service_desired_count   = 1
  ecs_service_iam_role        = ""

  ecs_service_launch_type         = "FARGATE"
  ecs_service_platform_version    = "LATEST"
  ecs_service_scheduling_strategy = "REPLICA"

  ecs_service_network_configuration = [
    {
      subnets           = module.vpc.private_subnets_ids
      security_groups   = [module.sg-private.security_group_id]
      assign_public_ip  = false
    }
  ]

  ecs_service_deployment_controller = [
    {
      type = "ECS"
    }
  ]

  ecs_service_load_balancer = [
     {
         target_group_arn    = module.alb.lb_tg_arn
         container_name      = "nginx"
         container_port      = 80
     },
  ]

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ecs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

  depends_on = [
    module.ecs_cluster,
    module.ecs_task_definition,
    module.iam_role_ex,
    module.iam_role
  ]

}
