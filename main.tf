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
  tags = local.vpc_final_tags
}


