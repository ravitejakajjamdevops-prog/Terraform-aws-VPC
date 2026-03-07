resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true  
  tags = local.vpc_final_tags
}
resource "aws_internet_gateway" "Loukya" {
  vpc_id = aws_vpc.main.id

  tags = local.vpc_final_tags
}
resource "aws_subnet" "roboshop_public" {
  count = length(var.Public_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.Public_subnet[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
        }
  ) 
}
resource "aws_subnet" "roboshop_private" {
  count = length(var.Private_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
        }
  ) 
}

resource "aws_subnet" "roboshop_database" {
  count = length(var.database_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
        }
  ) 
}



