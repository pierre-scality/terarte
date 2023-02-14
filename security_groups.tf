# resolve artifacts ip as local
data "dns_a_record_set" "eve_artifacts" {
  host = "eve.devsca.com"
}
data "dns_a_record_set" "github_artifacts" {
  host = "artifacts.scality.net"
}
locals {
  eve_artifacts_ip = join(",", formatlist("%s/32", data.dns_a_record_set.eve_artifacts.addrs))
  github_artifacts_ip = join(",", formatlist("%s/32", data.dns_a_record_set.github_artifacts.addrs))
}

# Inter-instance traffic (allow all)
resource "aws_security_group" "ring" {
	name = "${var.this_deployment}${var.os}_ring"
	vpc_id = aws_vpc.setup_team.id

	tags = {
		Name = "${var.this_deployment}ring"
		Spawner = "terraform"
		User = var.current_user
	}
}

resource "aws_security_group_rule" "ring_allow_ingress_subnets" {
	type        = "ingress"
	from_port   = 0
	to_port     = 65535
	protocol    = "all"
	cidr_blocks = [
		aws_subnet.internal_a.cidr_block,
		aws_subnet.external_a.cidr_block,
	]
	security_group_id = aws_security_group.ring.id
}

resource "aws_security_group_rule" "ring_allow_egress_subnets" {
	type            = "egress"
	from_port       = 0
	to_port         = 65535
	protocol        = "all"
	cidr_blocks     = [
		aws_subnet.internal_a.cidr_block,
		aws_subnet.external_a.cidr_block,
	]
	security_group_id = aws_security_group.ring.id
}

resource "aws_security_group_rule" "ring_allow_egress_internet" {
	count             = 1 - var.offline  # Remove access to Internet if in offline mode
	type              = "egress"
	from_port         = 0
	to_port           = 65535
	protocol          = "all"
	cidr_blocks       = ["0.0.0.0/0"]
	security_group_id = aws_security_group.ring.id
}

# Allow pull from eve.devsca.com range, artifacts.scality.net and packages.scality.com on supervisor
resource "aws_security_group_rule" "ring_allow_egress_scality" {
	count             = var.offline
	type              = "egress"
	from_port         = 0
	to_port           = 65535
	protocol          = "all"
	cidr_blocks       = [
		local.eve_artifacts_ip,
		local.github_artifacts_ip,
		var.packages_scality_com_eu_ip_range,
		var.packages_scality_com_us_ip_range,
	]
	security_group_id = aws_security_group.ring.id
}

# Traffic from Scality IP (allow SSH and Supervisor Web UI)
resource "aws_security_group" "scality_office" {
	name = "${var.this_deployment}${var.os}_scality_office"
	vpc_id = aws_vpc.setup_team.id

	tags = {
		Name = "${var.this_deployment}scality_office"
		Spawner = "terraform"
		User = var.current_user
	}
}

resource "aws_security_group_rule" "ring_allow_ingress_scality_office_ssh" {
	type            = "ingress"
	from_port       = 22
	to_port         = 22
	protocol        = "tcp"
	cidr_blocks     = [
		
		var.scality_office_ip_colt,
		var.scality_office_ip_orange,
		var.scality_vpn_ip,
		var.scality_vpn_tk,
		var.scality_office_sf_ip

	]
	security_group_id = "${aws_security_group.scality_office.id}"
}

resource "aws_security_group_rule" "ring_allow_ingress_scality_office_supervisor_http" {
	type            = "ingress"
	from_port       = 80
	to_port         = 80
	protocol        = "tcp"
	cidr_blocks     = [
		
		var.scality_office_ip_colt,
		var.scality_office_ip_orange,
		var.scality_vpn_ip,
		var.scality_vpn_tk,
		var.scality_office_sf_ip,
	]
	security_group_id = aws_security_group.scality_office.id
}

resource "aws_security_group_rule" "ring_allow_ingress_scality_office_supervisor_https" {
	type            = "ingress"
	from_port       = 443
	to_port         = 443
	protocol        = "tcp"
	cidr_blocks     = [
		
		var.scality_office_ip_colt,
		var.scality_office_ip_orange,
		var.scality_vpn_ip,
		var.scality_vpn_tk,
		var.scality_office_sf_ip,
	]
	security_group_id = aws_security_group.scality_office.id
}

resource "aws_security_group_rule" "allow_all_access" {
  count = var.training == 1 ? 1 : 0
	type            = "ingress"
	from_port       = 0
	to_port         = 65535
	protocol        = "all"
	cidr_blocks     = [
		var.scality_office_ip_colt,
		var.scality_office_ip_orange,
		var.scality_vpn_ip,
		var.scality_vpn_tk,
		var.scality_office_sf_ip,
	]
	security_group_id = aws_security_group.scality_office.id
}

resource "aws_security_group_rule" "ring_allow_ingress_scality_office_dsup_https" {
	type            = "ingress"
	from_port       = 3443
	to_port         = 3443
	protocol        = "tcp"
	cidr_blocks     = [
		
		var.scality_office_ip_colt,
		var.scality_office_ip_orange,
		var.scality_vpn_ip,
		var.scality_vpn_tk,
		var.scality_office_sf_ip,
	]
	security_group_id = aws_security_group.scality_office.id
}
resource "aws_security_group_rule" "ring_allow_ingress_scality_office_artesca_adm" {
	type            = "ingress"
	from_port       = 8443
	to_port         = 8443
	protocol        = "tcp"
	cidr_blocks     = [
		
		var.scality_office_ip_colt,
		var.scality_office_ip_orange,
		var.scality_vpn_ip,
		var.scality_vpn_tk,
		var.scality_office_sf_ip,
	]
	security_group_id = aws_security_group.scality_office.id
}
# Add additional security rules
