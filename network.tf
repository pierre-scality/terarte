resource "aws_vpc" "setup_team" {
	cidr_block = "10.0.0.0/16"
	enable_dns_support   = true
	enable_dns_hostnames = true

	tags = {
		Name = "${var.this_deployment}setup-team"
		Spawner = "terraform"
		User = var.current_user
	}
}

###################
# Internal networks

# The NAT Gateway is for internal subnets with instances without public IPs (i.e.: all instances but the supervisor)
resource "aws_eip" "nat_gateway" {
	vpc = true
}

resource "aws_nat_gateway" "internal" {
	allocation_id = aws_eip.nat_gateway.id
	subnet_id     = aws_subnet.external_a.id

	tags = {
		Name = "${var.this_deployment}internal"
		Spawner = "terraform"
		User = var.current_user
	}
}

resource "aws_route_table" "internal" {
	vpc_id = aws_vpc.setup_team.id

	tags = {
		Name = "${var.this_deployment}internal"
		Spawner = "terraform"
		User = var.current_user
	}
}

resource "aws_route" "internal_to_internet" {
	count                  = 1 - var.offline  # Remove route to Internet if in offline mode
	route_table_id         = aws_route_table.internal.id
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id         = aws_nat_gateway.internal.id
}

resource "aws_subnet" "internal_a" {
	availability_zone = "${var.region}a"
	vpc_id     = aws_vpc.setup_team.id
	cidr_block = "10.0.1.0/24"

	tags = {
		Name = "${var.this_deployment}internal_a"
		Spawner = "terraform"
		User = var.current_user
	}
}
resource "aws_route_table_association" "internal_a" {
 	subnet_id      = aws_subnet.internal_a.id
	route_table_id = aws_route_table.internal.id
}


###################
# External networks

# The Internet Gateway is for external subnets with instances with public IPs (i.e.: the supervisor)
resource "aws_internet_gateway" "external" {
	vpc_id = aws_vpc.setup_team.id

	tags = {
		Name = "${var.this_deployment}external"
		Spawner = "terraform"
		User = var.current_user
	}
}

resource "aws_route_table" "external" {
	vpc_id = aws_vpc.setup_team.id

	tags = {
		Name = "${var.this_deployment}external"
		Spawner = "terraform"
		User = var.current_user
	}
}

# We can't disable this route if in offline mode because we wouldn't be able to connect to the supervisor
# The trick here is to simply block all traffic not targeted to Scality office IP (see security_groups.tf)
resource "aws_route" "external_to_internet" {
	route_table_id         = aws_route_table.external.id
	destination_cidr_block = "0.0.0.0/0"
	gateway_id             = aws_internet_gateway.external.id
}

resource "aws_subnet" "external_a" {
	availability_zone = "${var.region}a"
	vpc_id     = aws_vpc.setup_team.id
	cidr_block = "10.0.11.0/24"

	tags = {
		Name = "${var.this_deployment}external_a"
		Spawner = "terraform"
		User = var.current_user
	}
}

resource "aws_route_table_association" "external_a" {
	subnet_id      = aws_subnet.external_a.id
	route_table_id = aws_route_table.external.id
}