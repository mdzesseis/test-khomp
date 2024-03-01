resource "aws_vpc" "khomp-test-VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "khomp-test-VPC"
  }
}

resource "aws_subnet" "khomp-test-subnet" {
  vpc_id     = aws_vpc.khomp-test-VPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "khomp-test-subnet"
  }
}

resource "aws_internet_gateway" "khomp-test-internet-gateway" {
  vpc_id = aws_vpc.khomp-test-VPC.id

  tags = {
    Name = "khomp-test-internet-gateway"
  }
}

resource "aws_route_table" "khomp-test-route-table" {
  vpc_id = aws_vpc.khomp-test-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.khomp-test-internet-gateway.id
  }

  tags = {
    Name = "khomp-test-route-table"
  }
}

resource "aws_route_table_association" "khomp-test-route-table-association" {
  subnet_id      = aws_subnet.khomp-test-subnet.id
  route_table_id = aws_route_table.khomp-test-route-table.id
}

resource "aws_security_group" "khomp-test-security-group" {
  name        = "khomp-test-security-group"
  description = "Allow SSH in port 22"
  vpc_id      = aws_vpc.khomp-test-VPC.id

  tags = {
    Name = "khomp-test-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "khomp-test-security-group-ingress-rule-allow-ssh-ipv4" {
  security_group_id = aws_security_group.khomp-test-security-group.id
  cidr_ipv4         = "xxx.xxx.xxx.xxx/xx" #Insert especif ip for connection ssh
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "khomp-test-security-group-ingress-rule-allow-ssh-ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "khomp-test-security-group-egress-rule-allow-ssh-ipv4" {
  security_group_id = aws_security_group.khomp-test-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Name = "khomp-test-security-group-egress-rule-allow-ssh-ipv4"
  }
}

resource "aws_security_group" "khomp-web-test-security-group" {
  name        = "khomp-web-test-security-group"
  description = "Allow TCP in port 80"
  vpc_id      = aws_vpc.khomp-test-VPC.id

  tags = {
    Name = "khomp-web-test-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "khomp-web-test-security-group-ingress-rule-allow-ssh-ipv4" {
  security_group_id = aws_security_group.khomp-web-test-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "khomp-web-test-security-group-ingress-rule-allow-ssh-ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "khomp-web-test-security-group-egress-rule-allow-ssh-ipv4" {
  security_group_id = aws_security_group.khomp-web-test-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Name = "khomp-web-test-security-group-egress-rule-allow-ssh-ipv4"
  }
}