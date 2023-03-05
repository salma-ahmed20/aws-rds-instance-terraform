#create db instance
 resource "aws_db_instance" "myrds" {
   allocated_storage   = 10
   db_name             = "mydb"
   engine              = "mysql"
   engine_version       = "5.7"
   instance_class      = "db.t2.micro"
   username            = "admin"
   password            = "Passw0rd!123"
   parameter_group_name = "default.mysql5.7"

   skip_final_snapshot = true
   multi_az = true

   db_subnet_group_name = aws_db_subnet_group.subnet-group.id
   vpc_security_group_ids = [aws_security_group.db-sg.id]

   tags = {
     Name = "MyRDS"
   }
 }

#create security group for db
resource "aws_security_group" "db-sg" {
  name = "terraform-sg-db"
  vpc_id = var.vpc_id
  tags = {
    Name = "test-sg"
    type = "terraform-test-security-group"
  }

  ingress {
    description      = "mysql"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    # cidr_blocks      = [aws_security_group.web-sg.id]
    cidr_blocks = [ "10.0.0.0/16" ]
  }

}

#create subnet group for db
resource "aws_db_subnet_group" "subnet-group" {
  name       = "rds-subnet-group"
  subnet_ids = [for subnet in var.private_subnet : subnet.id]
  tags = {
    Name = "rds-subnet-group"
  }
}
