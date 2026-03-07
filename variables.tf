variable "project" {
    type = string
}
variable "environment" {

    type = string
}
variable "vpc_cidr"{
    type = string
    default = "10.0.0.0/24"
}
variable "vpc_tags"{
    type = map
    default = {}
}
variable "Public_subnet" {
    type = list
    default = ["10.0.1.0/24","10.0.2.0/24"]
}