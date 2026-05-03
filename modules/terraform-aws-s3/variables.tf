variable "project_name" {
  description = "Project identifier used in resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
}

variable "bucket_suffix" {
  description = "Suffix appended to the bucket name to identify its purpose (e.g. 'assets', 'backups', 'artifacts')."
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket. Recommended for production workloads."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of a KMS key for server-side encryption. If null, AES-256 (SSE-S3) is used."
  type        = string
  default     = null
}

variable "cross_account_arns" {
  description = "List of IAM principal ARNs from other AWS accounts that should have read/write access to this bucket. If null, no cross-account access is granted."
  type        = list(string)
  default     = null
}

variable "lifecycle_rules" {
  description = <<-EOT
    List of lifecycle rules to apply to the bucket. Each rule supports:
    - id (string, required): unique rule identifier
    - enabled (bool, required): whether the rule is active
    - prefix (string, optional): object key prefix to filter on
    - transitions (list, optional): list of { days, storage_class } objects
    - expiration_days (number, optional): delete objects after N days
    - noncurrent_version_transitions (list, optional): list of { days, storage_class } for non-current versions
    - noncurrent_version_expiration_days (number, optional): delete non-current versions after N days
  EOT
  type        = any
  default     = []
}

variable "global_tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}
