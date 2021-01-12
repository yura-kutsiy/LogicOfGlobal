provider "aws" {
  region = "eu-central-1"
}

#create security group
resource "aws_security_group" "security_group" {
  name        = "web_server"
  description = "security_group_for_web_server"
  vpc_id      = aws_vpc.main_vpc.id
  #HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #HTTPS
  ingress {
    from_port   = 433
    to_port     = 433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #RDP
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
  }

  #WinRM
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5985
    protocol    = "tcp"
    to_port     = 5985
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5986
    protocol    = "tcp"
    to_port     = 5986
  }

}

#create instance in AZ-a
resource "aws_instance" "win_serv_2019_1-a" {
  ami             = "ami-01b65a06ec09db85c"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_1-a.id
  key_name        = "aws-key-Frankfurt"
  security_groups = [aws_security_group.security_group.id]
  user_data       = file("server_script.ps1")

  tags = {
    Name = "Win_2019_web_server_1-a"
  }
}

#create instance in AZ-b
resource "aws_instance" "win_serv_2019_1-b" {
  ami             = "ami-01b65a06ec09db85c"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_1-b.id
  key_name        = "aws-key-Frankfurt"
  security_groups = [aws_security_group.security_group.id]
  user_data       = file("server_script.ps1")

  tags = {
    Name = "Win_2019_web_server_1-b"
  }
}
#target group
resource "aws_lb_target_group" "target_group" {
  name     = "FirstTargetGroup"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main_vpc.id
}

resource "aws_lb_listener" "web_server" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id = aws_instance.win_serv_2019_1-a.id
  port = 80
}

resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id = aws_instance.win_serv_2019_1-b.id
  port = 80
}
