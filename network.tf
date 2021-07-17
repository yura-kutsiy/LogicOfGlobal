#create vpc
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "main_vpc"
  }
}

#create internet gatteway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "internet_gw"
  }
}

#create public subnet in AZ_1-a
resource "aws_subnet" "public_subnet_1-a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "public_subnet_1-a"
  }
}

#create public subnet in AZ_1-b
resource "aws_subnet" "public_subnet_1-b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"

  tags = {
    Name = "public_subnet_1-b"
  }
}

#create route table
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main_route_table"
  }
}

#association route table public subnet_1-a
resource "aws_route_table_association" "route_public_1-a" {
  subnet_id      = aws_subnet.public_subnet_1-a.id
  route_table_id = aws_route_table.route.id
}

#association route table public subnet_1-b
resource "aws_route_table_association" "route_public_1-b" {
  subnet_id      = aws_subnet.public_subnet_1-b.id
  route_table_id = aws_route_table.route.id
}

#create Network Load Balancer
resource "aws_lb" "load_balancer" {
  name                             = "LoadBalancer"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet_1-a.id
    allocation_id = aws_eip.eip_subnet_1-a.id
  }
  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet_1-b.id
    allocation_id = aws_eip.eip_subnet_1-b.id
  }
}

#elastic ip public subnet 1-a
resource "aws_eip" "eip_subnet_1-a" {

  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "eip_subnet_1-a"
  }
}

#elastic ip public subnet 1-b
resource "aws_eip" "eip_subnet_1-b" {

  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "eip_subnet_1-b"
  }
}
