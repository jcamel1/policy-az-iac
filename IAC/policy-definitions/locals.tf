
locals {
  json_policy_files = fileset("${path.module}", "/lib/*/policy.json")
  json_policy__data  = [for f in local.json_policy_files : jsondecode(file("${path.module}/${f}"))]

  json_assignment_files = fileset("${path.module}", "/lib/*/assign*.json")
  json_assignment_data  = [for f in local.json_assignment_files : jsondecode(file("${path.module}/${f}"))]
}

