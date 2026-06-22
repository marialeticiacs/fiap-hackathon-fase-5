variable "project_name" {
	type = string
}

variable "environment" {
	type = string
}

variable "private_subnet_ids" {
	type = list(string)
}

variable "rds_sg_id" {
	type = string
}

variable "db_instance_class" {
	type    = string
	default = "db.t3.micro"
}

variable "db_engine_version" {
	type    = string
	default = "16"
}

variable "db_deletion_protection" {
	type    = bool
	default = false
}

variable "db_name" {
	type    = string
	default = "solidarytech"
}

variable "db_username" {
	type    = string
	default = "solidarytech_admin"
}