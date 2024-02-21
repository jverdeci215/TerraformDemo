#Formerly main.tf

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "bjgomes"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "bjgomes-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = var.public_subnet_count
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.public_subnet_count)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "bjgomes-private-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "public" {
  count = var.public_subnet_count
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route" "igw" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}


resource "aws_route_table_association" "private" {
  count = var.public_subnet_count
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private[count.index].id
}

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  nat_gateway_id = aws_nat_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_eip" "main" {
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.allocation_id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "bjgomes-NAT"
  }

  depends_on = [aws_internet_gateway.main]
}
