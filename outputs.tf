output "azs_info" {
    value = data.aws_availability_zones.fetch
}
output "vpc_id" {
    value = aws_vpc.main.id
}
output "Public_subnet_ids1" {
    value = aws_subnet.roboshop_public[*].id
}
output "Private_subnet_ids" {
    value = aws_subnet.roboshop_private[*].id
}
output "database_subnet_ids" {
    value = aws_subnet.roboshop_database[*].id
}