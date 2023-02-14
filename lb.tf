
resource "aws_instance" "lb-1" {
  depends_on = [null_resource.generate_supervisor_ssh_key]
	ami = lookup(var.available_images, "${var.region}.${var.os}")

	availability_zone = "${var.region}a"
	instance_type     = lookup(var.instance_size, "connector")
	key_name          = "${var.ssh_key_name}_${var.current_user}"


  vpc_security_group_ids = [
    aws_security_group.ring.id,
    aws_security_group.scality_office.id,
  ]
  subnet_id = aws_subnet.external_a.id
  associate_public_ip_address = true

	root_block_device {
		volume_type = "gp3"
		volume_size = var.disk_os
		delete_on_termination = true
	}

  connection {
    host = self.public_ip
    type = "ssh"
    user = var.remote_user[var.os]
    private_key = file(var.ssh_key_path)
  }

	provisioner "remote-exec" {
		inline = [
			var.init_specific_commands[var.os],
			var.init_ssh,
			var.reload_ssh[var.os],
		]
	}

	provisioner "file" {
		on_failure  = continue
		#source      = "ssh_key_${var.os}_${var.current_user}.pub"
		source      = "ssh_key_${var.this_deployment}.pub"
		destination = "/tmp/root_ssh_key.pub"
	}

  provisioner "file" {
    on_failure  = continue
    source      = "ssh_key_${var.this_deployment}"
    destination = "/tmp/root_ssh_key"
  }


  provisioner "file" {
    on_failure  = continue
    source      = "scripts"
    destination = "/tmp/"
  }


provisioner "remote-exec" {
  inline = [
    "echo Setting host name ${var.this_deployment}-lb",
    "sudo hostnamectl set-hostname ${var.this_deployment}-lb",
    "echo Copy root public key to authorized_keys",
    "sudo cp /tmp/root_ssh_key.pub /root/.ssh/authorized_keys",
    "sudo cp /tmp/root_ssh_key.pub /root/.ssh/ssh_key_${var.this_deployment}.pub",
    "sudo cp /tmp/root_ssh_key /root/.ssh/ssh_key_${var.this_deployment}",
    "sudo cp /tmp/root_ssh_key /root/.ssh/id_ecdsa",
    "sudo cp /tmp/root_ssh_key /root/.ssh/root_ssh_key",
    "sudo chown 600 /root/.ssh/id_ecdsa",
    "sudo chown root:root /root/.ssh/authorized_keys",
    "sudo chmod 600 /root/.ssh/authorized_keys",
    "sudo chmod 600 /root/.ssh/ssh_key_${var.this_deployment}",
    "sudo mv /tmp/scripts /root/",

  ]
}


	tags = {
		Name = "${var.this_deployment}lb-1"
		Spawner = "terraform"
		User = var.current_user
		Buildid = "${var.this_deployment}centos-7"
	}
}

resource "aws_eip" "loadbalancer_eip" {
  instance = "${aws_instance.lb-1.id}"
  vpc = true
}

output "LB_eip" {
  value = aws_eip.loadbalancer_eip
}   

output "LB_ssh" {
  value = "ssh -i ${local.wrkdir}/ssh_key_${var.this_deployment} root@${aws_eip.loadbalancer_eip.public_ip}"
}
