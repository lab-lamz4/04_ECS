module "iam_role" {
  source      = "../../modules/iam_role"
  name        = "epam-leodorov-ecs"
  environment = "learning"

  # Using IAM role
  enable_iam_role      = true
  iam_role_name        = "ecs-ecr-access"
  iam_role_description = "Role to get images from ecr"
  # Inside additional_files directory I will add additional policies for assume_role_policy usage in the future....
  iam_role_assume_role_policy = file("additional_files/assume_role_policy.json")

  iam_role_force_detach_policies = true
  iam_role_path                  = "/"
  iam_role_max_session_duration  = 3600

  # Using IAM role policy
  enable_iam_role_policy = false

  # Using IAM role policy attachment
  enable_iam_role_policy_attachment      = true
  iam_role_policy_attachment_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"]

  # Using IAM instance profile
  enable_iam_instance_profile = false

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ecs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
}

module "iam_role_ex" {
  source      = "../../modules/iam_role"
  name        = "epam-leodorov-ecs"
  environment = "learning"

  # Using IAM role
  enable_iam_role      = true
  iam_role_name        = "ecs-ecr-execution"
  iam_role_description = "Provides access to other AWS service resources that are required to run Amazon ECS tasks"
  # Inside additional_files directory I will add additional policies for assume_role_policy usage in the future....
  iam_role_assume_role_policy = file("additional_files/assume_role_policy.json")

  iam_role_force_detach_policies = true
  iam_role_path                  = "/"
  iam_role_max_session_duration  = 3600

  # Using IAM role policy
  enable_iam_role_policy = false

  # Using IAM role policy attachment
  enable_iam_role_policy_attachment      = true
  iam_role_policy_attachment_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]

  # Using IAM instance profile
  enable_iam_instance_profile = false

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ecs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
}