variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "eks_node_security_group_id" {
  description = "Security group ID attached to EKS worker nodes, allowed to reach Redis"
  type        = string
}
