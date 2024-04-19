variable "tags" {
  description = "Tags for the cluster and additional resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}

variable "budget_amount" {
  description = "The threshold above which notifications about the budget should be triggered"
  type        = string
}

variable "budget_unit" {
  description = "Unit in which the above threshold should be interpreted. USD, GB, ..."
  type        = string
}

variable "budget_time_unit" {
  description = "Unit of time for the notification frequency. MONTHLY, QUARTERLY, ANNUALLY, or DAILY"
  type        = string
  default     = "MONTHLY"
}

variable "decrypted_slack_webhook_url" {
  description = "The Slack URL that the notifier should push to, after it's been decrypted by SOPS"
  type        = string
  sensitive   = true
}

variable "slack_channel" {
  description = "Name of the slack channel that notifications should be sent to"
  type        = string
}
