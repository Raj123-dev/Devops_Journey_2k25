variable "project_name" {
  description = "Project name used as a prefix for all resources"
  type        = string
  default     = "demo-project"
}
 
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
 
variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
}
 
variable "ec2_root_storage_size" {
  type        = number
  default     = 10
}
 
 