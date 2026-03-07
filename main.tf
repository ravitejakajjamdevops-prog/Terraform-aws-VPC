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
  cidr_block = var.Private_subnet[count.index]
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
resource "aws_route_table" "Public_routetable" {
  vpc_id = aws_vpc.main.id
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public"
        }
  )
}
resource "aws_route_table" "Private_routetable" {
  vpc_id = aws_vpc.main.id
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private"
        }
  )
}
resource "aws_route_table" "database_routetable" {
  vpc_id = aws_vpc.main.id
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-database"
        }
  )
}
resource "aws_route" "Public-route" {
  route_table_id            = aws_route_table.Public_routetable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Loukya.id
}
resource "aws_eip" "elasticrobo" {
    domain   = "vpc"
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-nat"
        }
  )  
}
resource "aws_nat_gateway" "RoboNat" {
  allocation_id = aws_eip.elasticrobo.id
  subnet_id     = aws_subnet.roboshop_database[0].id
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-NGAT"
        }
  )  
  depends_on = [aws_internet_gateway.Loukya]
}
resource "aws_route" "Private-route" {
  route_table_id            = aws_route_table.Private_routetable.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.RoboNat.id
}
resource "aws_route" "Database-route" {
  route_table_id            = aws_route_table.database_routetable.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.RoboNat.id
}
resource "aws_route_table_association" "public" {
  count = length(var.Public_subnet)
  subnet_id      = aws_subnet.roboshop_public[count.index].id
  route_table_id = aws_route_table.Public_routetable[count.index].id
}
resource "aws_route_table_association" "private" {
  count = length(var.Private_subnet)
  subnet_id      = aws_subnet.roboshop_private[count.index].id
  route_table_id = aws_route_table.Private_routetable[count.index].id
}
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet)
  subnet_id      = aws_subnet.roboshop_database[count.index].id
  route_table_id = aws_route_table.database_routetable[count.index].id
}
