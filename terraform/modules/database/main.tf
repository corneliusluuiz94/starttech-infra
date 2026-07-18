terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_elasticache_subnet_group" "starttech-redis-subnet-group" {
  name       = "starttech-redis-subnet-group"
  subnet_ids = var.private_subnet_ids
}

# Security group: allow Redis (6379) only from EKS worker node SG
resource "aws_security_group" "starttech-redis-sg" {
  name        = "starttech-redis-sg"
  description = "Allow Redis access only from EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Redis from EKS nodes"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.eks_node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "starttech-redis-sg"
  }
}

resource "aws_elasticache_cluster" "starttech-redis" {
  cluster_id           = "starttech-redis"
  engine               = "redis"
  engine_version       = "7.1"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379

  subnet_group_name  = aws_elasticache_subnet_group.starttech-redis-subnet-group.name
  security_group_ids = [aws_security_group.starttech-redis-sg.id]

  tags = {
    Name = "starttech-redis"
  }
}
