
locals {
  json_policyset__files = fileset("${path.module}", "/lib/*/policyset.json")
  json_policyset_data   = [for f in local.json_policyset__files : jsondecode(file("${path.module}/${f}"))]

  json_assignment_files = fileset("${path.module}", "/lib/*/assign*.json")
  json_assignment_data  = [for f in local.json_assignment_files : jsondecode(file("${path.module}/${f}"))]
}
