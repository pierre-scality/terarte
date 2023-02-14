resource "aws_key_pair" "cloud" {
	key_name   = "${var.ssh_key_name}_${var.current_user}"
	public_key = file("${var.ssh_key_path}.pub")
}

