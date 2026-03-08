data "aws_availability_zones" "fetch"{
    state = "available"
}
data "aws_vpc" "default" {
    default = true
}