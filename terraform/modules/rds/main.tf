# Subnet group para o RDS
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-subnet-group"
  }
}

# Senha do banco gerada automaticamente
resource "random_password" "db_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}?"
}

# Armazenar senha no SSM Parameter Store
resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.project_name}/${var.environment}/db/password"
  type  = "SecureString"
  value = random_password.db_password.result

  tags = {
    Name = "${var.project_name}-${var.environment}-db-password"
  }
}

# RDS PostgreSQL Multi-AZ
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-${var.environment}-postgres"
  engine            = "postgres"
  engine_version    = "16.2"
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  multi_az               = var.environment == "production" ? true : false
  publicly_accessible    = false
  deletion_protection    = var.environment == "production" ? true : false
  skip_final_snapshot    = var.environment == "production" ? false : true
  final_snapshot_identifier = "${var.project_name}-${var.environment}-final-snapshot"

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  performance_insights_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres"
  }
}