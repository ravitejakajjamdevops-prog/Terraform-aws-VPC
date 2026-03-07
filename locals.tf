locals {
    common_tags = {

        Project = var.project
        Environment = var.environment
        Terraform = true
    }

    vpc_final_tags = merge ( 
        local.common_tags,
        {
           Name = "${var.project}-${var.environment}"
        }
    )    
    az_names = slice(data.aws_availability_zones.fetch.names,0,2)    
    #Roboshop-dev-public-US-east-1a
    
}