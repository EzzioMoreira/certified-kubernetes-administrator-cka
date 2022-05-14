variable instance_type {
    default = "t3a.medium"
    type = string
    description = "Type of instance aws ec2"
}

variable instance_name {
  type        = list
  default     = ["srv-01", "srv-02", "srv-03"]
  description = "Instance name used in tags"
}
