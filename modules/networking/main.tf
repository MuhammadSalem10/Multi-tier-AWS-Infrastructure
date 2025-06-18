
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Project     = var.environment
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-eip"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
}
