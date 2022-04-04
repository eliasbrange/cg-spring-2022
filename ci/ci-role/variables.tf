variable "name" {
  type = string
}

variable "subject_claim" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "state_buckets_policy_arn" {
  type = string
}

variable "permissions" {
  type = list(string)
}
