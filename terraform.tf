#vpc
resource "aws_vpc" "terra-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terra-vpc"
  }
}
#Internet gateway
resource "aws_internet_gateway" "terra-igw"{
    vpc_id = aws_vpc.terra-vpc.id
    tags = {
        Name = "terra-igw"
    }
}
#Nat Gateway
resource "aws_eip" "terra-nip"{
    vpc = true
    tags = {
        Name = "terra-nip"
    }
}
resource "aws_nat_gateway" "terra-ngw"{
    allocation_id = aws_eip.terra-nip.id
    subnet_id   = aws_subnet.terra-sub-pub-a.id
    tags = {
        Name = "terra-ngw"
    }
}
#Terraform AWS Subnet
# public
resource "aws_subnet" "terra-sub-pub-a"{
    vpc_id  = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.1.0/24"
    availability_zone = "ap-northeast-3a"
    # public ip를 할당하기 위해 true로 설정
    map_public_ip_on_launch = true

    tags = {
        Name = "terra-sub-pub-a"
    }

}
resource "aws_subnet" "terra-sub-pub-c"{
    vpc_id  = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.2.0/24"
    availability_zone = "ap-northeast-3c"
    map_public_ip_on_launch = true

    tags = {
        Name = "terra-sub-pub-c"
    }

}

# private web
resource "aws_subnet" "terra-sub-pri-a-web"{
    vpc_id  = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.4.0/24"
    availability_zone = "ap-northeast-3a"

    tags = {
        Name = "terra-sub-pri-a-web"
    }

}
resource "aws_subnet" "terra-sub-pri-c-web"{
    vpc_id  = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.6.0/24"
    availability_zone = "ap-northeast-3c"

    tags = {
        Name = "terra-sub-pri-c-web"
    }

}
# private was
resource "aws_subnet" "terra-sub-pri-a-was"{
    vpc_id  = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.8.0/24"
    availability_zone = "ap-northeast-3a"

    tags = {
        Name = "terra-sub-pri-a-was"
    }

}
resource "aws_subnet" "terra-sub-pri-c-was"{
    vpc_id  = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.10.0/24"
    availability_zone = "ap-northeast-3c"

    tags = {
        Name = "terra-sub-pri-c-was"
    }

}
# private db
resource "aws_subnet" "terra-sub-pri-a-db"{
    vpc_id  = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.12.0/24"
    availability_zone = "ap-northeast-3a"

    tags = {
        Name = "terra-sub-pri-a-db"
    }

}
resource "aws_subnet" "terra-sub-pri-c-db"{
    vpc_id  = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.14.0/24"
    availability_zone = "ap-northeast-3c"

    tags = {
        Name = "terra-sub-pri-c-db"
    }

}

#Route Table
# public > igw
resource "aws_route_table" "terra-rt-pub" {
    vpc_id = aws_vpc.terra-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terra-igw.id
    }
    tags = {
        Name = "terra-rt-pub"
    }
}
# public subnet을 public route table에 연결
resource "aws_route_table_association" "terra-rtass-pub-a"{
    subnet_id = aws_subnet.terra-sub-pub-a.id
    route_table_id = aws_route_table.terra-rt-pub.id
}

resource "aws_route_table_association" "terra-rtass-pub-c"{
    subnet_id = aws_subnet.terra-sub-pub-c.id
    route_table_id = aws_route_table.terra-rt-pub.id
}

# private web > nat
resource "aws_route_table" "terra-rt-pri-web"{
    vpc_id = aws_vpc.terra-vpc.id

    tags = {
       Name = "terra-rt-pri-web"
   }
}
resource "aws_route" "terra-r-pri-web"{
    route_table_id = aws_route_table.terra-rt-pri-web.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terra-ngw.id
}

# private web subnet을 pirvate route table에 연결
resource "aws_route_table_association" "terra-rtass-pri-a-web"{
    subnet_id = aws_subnet.terra-sub-pri-a-web.id
    route_table_id = aws_route_table.terra-rt-pri-web.id
}

resource "aws_route_table_association" "terra-rtass-pri-c-web"{
    subnet_id = aws_subnet.terra-sub-pri-c-web.id
    route_table_id = aws_route_table.terra-rt-pri-web.id
}
# private was > nat
resource "aws_route_table" "terra-rt-pri-was"{
    vpc_id = aws_vpc.terra-vpc.id

    tags = {
       Name = "terra-rt-pri-was"
   }
}
resource "aws_route" "terra-r-pri-was"{
    route_table_id = aws_route_table.terra-rt-pri-was.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terra-ngw.id
}

# private was subnet을 pirvate route table에 연결
resource "aws_route_table_association" "terra-rtass-pri-a-was"{
    subnet_id = aws_subnet.terra-sub-pri-a-was.id
    route_table_id = aws_route_table.terra-rt-pri-was.id
}

resource "aws_route_table_association" "terra-rtass-pri-c-was"{
    subnet_id = aws_subnet.terra-sub-pri-c-was.id
    route_table_id = aws_route_table.terra-rt-pri-was.id
}
# private db > nat
resource "aws_route_table" "terra-rt-pri-db"{
    vpc_id = aws_vpc.terra-vpc.id

    tags = {
       Name = "terra-rt-pri-db"
   }
}
resource "aws_route" "terra-r-pri-db"{
    route_table_id = aws_route_table.terra-rt-pri-db.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terra-ngw.id
}

# private db subnet을 pirvate route table에 연결
resource "aws_route_table_association" "terra-rtass-pri-a-db"{
    subnet_id = aws_subnet.terra-sub-pri-a-db.id
    route_table_id = aws_route_table.terra-rt-pri-db.id
}

resource "aws_route_table_association" "terra-rtass-pri-c-db"{
    subnet_id = aws_subnet.terra-sub-pri-c-db.id
    route_table_id = aws_route_table.terra-rt-pri-db.id
}

#Security Group
resource "aws_security_group" "terra-sg-pub-bastion"{
    name    = "terra-sg-pub-bastion"
    description = "terra-sg-pub-bastion"
    vpc_id  = aws_vpc.terra-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "terra-sg-pub-bastion"
  }
}
#EC2
resource "aws_instance" "terra-ec2-pub-a-bastion"{
  ami = "ami-04f309177872e4a43"
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-3a"

  subnet_id = aws_subnet.terra-sub-pub-a.id
  key_name = "test"
  vpc_security_group_ids = [
      aws_security_group.terra-sg-pub-bastion.id
  ]
  tags = {
      Name = "terra-ec2-pub-a-bastion"
  }
}
#Terraform Web Was DB - Security Group & EC2
#Security Group-private 영역에서 a와 c존에 각각 두 대씩 instance 생성

#Web SG
resource "aws_security_group" "terra-sg-pri-web"{
    name    = "terra-sg-pri-web"
    description = "terra-sg-pri-web"
    vpc_id  = aws_vpc.terra-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.terra-sg-pub-bastion.id]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "terra-sg-pri-web"
  }
}
#Was SG
resource "aws_security_group" "terra-sg-pri-was"{
    name    = "terra-sg-pri-was"
    description = "terra-sg-pri-was"
    vpc_id  = aws_vpc.terra-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
   security_groups = [aws_security_group.terra-sg-pub-bastion.id]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.6.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "terra-sg-pri-was"
  }
}
#DB SG
# db
resource "aws_security_group" "terra-sg-pri-db"{
    name    = "terra-sg-pri-db"
    description = "terra-sg-pri-db"
    vpc_id  = aws_vpc.terra-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
     security_groups = [aws_security_group.terra-sg-pub-bastion.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "terra-sg-pri-db"
  }
}
#EC2
# web, db 이중화 구성
# a 대역에 ec2 생성
resource "aws_instance" "terra-ec2-pri-a-web1"{
  ami = "ami-04f309177872e4a43"
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-3a"

  subnet_id = aws_subnet.terra-sub-pri-a-web.id
  key_name = "test"
  vpc_security_group_ids = [
      aws_security_group.terra-sg-pri-web.id
  ]
  tags = {
      Name = "terra-ec2-pri-a-web1"
  }
}

# c 대역에 ec2 생성
resource "aws_instance" "terra-ec2-pri-c-web2"{
  ami = "ami-04f309177872e4a43"
  instance_type = "t3.nano"
  availability_zone = "ap-northeast-3c"

  subnet_id = aws_subnet.terra-sub-pri-c-web.id
  key_name = "test"
  vpc_security_group_ids = [
      aws_security_group.terra-sg-pri-web.id
  ]
  tags = {
      Name = "terra-ec2-pri-c-web2"
  }
}
#db
resource "aws_instance" "terra-ec2-pri-a-db1"{
  ami = "ami-04f309177872e4a43"
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-3a"

  subnet_id = aws_subnet.terra-sub-pri-a-db.id
  key_name = "test"
  vpc_security_group_ids = [
      aws_security_group.terra-sg-pri-db.id
  ]
  tags = {
      Name = "terra-ec2-pri-a-db1"
  }
}
resource "aws_instance" "terra-ec2-pri-c-db2"{
  ami = "ami-04f309177872e4a43"
  instance_type = "t3.nano"
  availability_zone = "ap-northeast-3c"

  subnet_id = aws_subnet.terra-sub-pri-c-db.id
  key_name = "test"
  vpc_security_group_ids = [
      aws_security_group.terra-sg-pri-db.id
  ]
  tags = {
      Name = "terra-ec2-pir-c-db2"
  }
}
# was 이중화 및 elb 붙여주기
resource "aws_instance" "terra-ec2-pri-a-was1"{
  ami = "ami-04f309177872e4a43"
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-3a"

  subnet_id = aws_subnet.terra-sub-pri-a-was.id
  key_name = "test"

# ebs 추가적으로 구성
  ebs_block_device{
    device_name ="/dev/sdb"
    volume_size  = "8"
  }

  vpc_security_group_ids = [
      aws_security_group.terra-sg-pri-was.id
  ]
  tags = {
      Name = "terra-ec2-pri-a-was1"
  }
}
resource "aws_instance" "terra-ec2-pri-c-was2"{
  ami = "ami-04f309177872e4a43"
  instance_type = "t3.nano"
  availability_zone = "ap-northeast-3c"

  subnet_id = aws_subnet.terra-sub-pri-c-was.id
  key_name = "test"

  ebs_block_device{
    device_name ="/dev/sdb"
    volume_size  = "8"
  }

  vpc_security_group_ids = [
      aws_security_group.terra-sg-pri-was.id
  ]
  tags = {
      Name = "terra-ec2-pri-c-was2"
  }
}

#web: 주소를 통해서 들어오므로 프론트단에 접속하기 때문에 http를 로드밸런싱하는 alb를 달아준다.
# alb 생성
resource "aws_lb" "terra-alb-web"{
    name    = "terra-alb-web"
    internal    = false			# 외부
    load_balancer_type = "application"
    security_groups = [aws_security_group.terra-sg-alb-web.id]	# alb는 sg 필요
    subnets     = [aws_subnet.terra-sub-pub-a.id, aws_subnet.terra-sub-pub-c.id]	# public subnet에서 web 통신
    tags = {
        Name = "terra-alb-web"
    }
}
# 타겟그룹 생성
resource "aws_lb_target_group" "terra-atg-web"{
    name    = "terra-atg-web"
    port    = "80"
    protocol   = "HTTP"
    vpc_id  = aws_vpc.terra-vpc.id
    target_type = "instance"
    tags = {
        Name = "terra-atg-web"
    }
}
# 리스너 생성
resource "aws_lb_listener" "terra-alt-web"{
    load_balancer_arn = aws_lb.terra-alb-web.arn
    port    = "80"
    protocol    = "HTTP"
    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.terra-atg-web.arn
    }
}
# 2개의 web attachement
resource "aws_lb_target_group_attachment" "terra-att-web1"{
    target_group_arn    = aws_lb_target_group.terra-atg-web.arn
    target_id   = aws_instance.terra-ec2-pri-a-web1.id
    port    = 80
}
resource "aws_lb_target_group_attachment" "terra-att-web2"{
    target_group_arn    = aws_lb_target_group.terra-atg-web.arn
    target_id   = aws_instance.terra-ec2-pri-c-web2.id
    port    = 80
}
# alb sg
resource "aws_security_group" "terra-sg-alb-web" {
  name        = "terra-sg-alb-web"
  description = "terra-sg-alb-web"
  vpc_id      = aws_vpc.terra-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
   Name = "terra-sg-alb-web"
  }
}
#was: ip port로 web에서 was로 접근하므로 tcp 통신을 로드밸런싱하는 nlb를 달아준다.
# nlb 생성
resource "aws_lb" "terra-nlb-was"{
    name    = "terra-nlb-was"
    internal    = true			# 내부 접근
    load_balancer_type = "network"
    subnets     = [aws_subnet.terra-sub-pri-a-web.id, aws_subnet.terra-sub-pri-c-web.id]	# web subnet에서 was를 바라봄
    tags = {
        Name = "terra-nlb-was"
    }
}

# 타겟그룹
# was에서 진행 될 tomcat의 경우, 8080 port로 통신된다.
resource "aws_lb_target_group" "terra-ntg-was"{
    name    = "terra-ntg-was"
    port    = "8080"
    protocol  = "TCP"
    vpc_id  = aws_vpc.terra-vpc.id
    target_type = "instance"
    tags = {
        Name = "terra-ntg-was"
    }
}

resource "aws_lb_listener" "terra-nlt-was"{
    load_balancer_arn = aws_lb.terra-nlb-was.arn
    port    = "8080"
    protocol    = "TCP"
    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.terra-ntg-was.arn
    }
}

resource "aws_lb_target_group_attachment" "terra-ntt-was1"{
    target_group_arn    = aws_lb_target_group.terra-ntg-was.arn
    target_id   = aws_instance.terra-ec2-pri-a-was1.id
    port    = 8080
}
resource "aws_lb_target_group_attachment" "terra-ntt-was2"{
    target_group_arn    = aws_lb_target_group.terra-ntg-was.arn
    target_id   = aws_instance.terra-ec2-pri-c-was2.id
    port    = 8080
}







