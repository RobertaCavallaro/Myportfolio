
provider "aws" {
  region  = "us-east-1"
}

// Create VPC
resource "aws_vpc" "custom_vpc" { #custom_vpc nome assegnato per terraform
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "terraform vpc" #nome che appare sul aws console
  }
}

// Create Subnet 1 in AZ 1a
resource "aws_subnet" "custom_subnet_1a" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a" 
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet1a" #public subnet
  }
}

// Create Subnet 2 in AZ 1b
resource "aws_subnet" "custom_subnet_1b" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"  
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet1b" #private subnet
  }
}

// Create Internet Gateway
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "CustomIGW"
  }
}

// Create Route Table updated with the above InternetGateWay
resource "aws_route_table" "custom_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }

  tags = {
    Name = "Myroutetable"
  }
}

// Subnet association in Route Table
resource "aws_route_table_association" "sub1a_association" {
  subnet_id      = aws_subnet.custom_subnet_1a.id
  route_table_id = aws_route_table.custom_rt.id
}

// Create Load Balancer
resource "aws_lb" "wordpress_lb" {
  name               = "wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.wordpress_sg.id]
  subnets            = [aws_subnet.custom_subnet_1a.id, aws_subnet.custom_subnet_1b.id]
}
// Create Target Group for Load Balancer, istanze di destinazione per il traffico gestito dal bilanciatore di carico
resource "aws_lb_target_group" "wordpress_target_group" {
  name     = "wordpress-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
}

// Create Listener for Load Balancer, Listener ascolta il traffico in arrivo e lo indirizza al Target Group corrispondente
resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.wordpress_lb.arn
  port              = 80
  protocol          = "HTTP"

 default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "Hello, WordPress is under construction!"
    }
  }
}


// Launch an EC2 instance for WordPress
resource "aws_instance" "wordpress_instance" {
  depends_on = [aws_subnet.custom_subnet_1a, aws_security_group.wordpress_sg] #depends on the whole object
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  key_name      = "robertakeypair" #keypair
  subnet_id     = aws_subnet.custom_subnet_1a.id  #Launch an EC2 instance for WordPress in the public subnet 
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

 
  tags = {
    Name = "WordPressInstance"
  }
}

// Create Security Group for WordPress
resource "aws_security_group" "wordpress_sg" {
  depends_on = [aws_vpc.custom_vpc]
  name        = "WordPressSecurityGroup"
  description = "Allow TLS inbound and outbound traffic for WordPress"
  vpc_id      = aws_vpc.custom_vpc.id

  // Ingress rules for HTTP and SSH #assh (port 22) I can access my ec2 instance remotely, HTTP the Client can access my WordPress site.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WordPressSecurityGroup"
  }
}

// Launch a manually pre-configured MySQL instance
resource "aws_instance" "mysql_instance" {
  depends_on = [aws_subnet.custom_subnet_1b, aws_security_group.mysql_sg]
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  key_name      = "robertakeypair"
  subnet_id     = aws_subnet.custom_subnet_1b.id #Launch EC2 instance for MySQL Server in the private subnet 
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  
  tags = {
    Name = "MySQLInstance"
  }
}

// Create Security Group for MySQL
resource "aws_security_group" "mysql_sg" {
  depends_on = [aws_vpc.custom_vpc]
  name        = "MySQLSecurityGroup"
  description = "Allow TLS inbound and outbound traffic for MySQL"
  vpc_id      = aws_vpc.custom_vpc.id

  // Ingress rule to allow MySQL traffic from WordPress SecurityGroups
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  // Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySQLSecurityGroup"
  }
}



// ... Additional configurations for setting up WordPress and MySQL ...
// Setup wordpress in ec2
# sudo su -
# apt-get update
# apt-get upgrade -y
# apt-get install apache2 -y
# apt-get install php7.2 php7.2-curl php7.2-mysql php7.2-mbstring php7.2-dom php7.2-gd -y
# apt-get install libapache2-mod-php7.2 -y
# apt-get install mysql-client -y
# cd /var/www/html
# rm -rf *
# wget https://wordpress.org/latest.tar.gz
# tar -xzvf latest.tar.gz
# mv wordpress/* ./
# rm -r wordpress latest.tar.gz
# chown -R www-data:www-data /var/www/html

// Setup mysql
# apt-get update
# apt-get upgrade -y
# apt-get install mysql-server mysql-client -y

# mysql_secure_installation
# - Enable Validate Password Plugin? No
# - Change the password for root? No
# - Remove anonymous users? Yes
# - Disallow root login remotely? Yes
# - Remove test database and access to it? Yes
# - Reload privilege table now? Yes

# nano /etc/mysql/mysql.conf.d/mysqld.cnf
#   - bind-address = private_ip
# service mysql restart

# mysql -uroot -p
# mysql> CREATE DATABASE wordpress;
# mysql> CREATE USER ‘wordpressUser‘@’wordpress_private_ip‘ IDENTIFIED BY ‘qawsedrf123‘;
# mysql> GRANT ALL PRIVILEGES ON wordpress.* TO ‘wordpressUser‘@’wordpress_private_ip‘;
# mysql> FLUSH PRIVILEGES;
# mysql> exit;



#resource "<provider>_<resource_type>" "name" {
#config options....
#key="value"
#}