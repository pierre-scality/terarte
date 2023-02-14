output "var_deployment" {
  value = var.this_deployment
}   

locals {
  wrkdir = abspath(path.module)
}

resource "aws_instance" "storage-1" {
  depends_on = [null_resource.generate_supervisor_ssh_key]
	ami = lookup(var.available_images, "${var.region}.${var.os}")

	availability_zone = "${var.region}a"
	instance_type     = lookup(var.instance_size, "storage")
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
    "echo Setting host name ${var.this_deployment}-1",
    "sudo hostnamectl set-hostname ${var.this_deployment}-1",
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
		Name = "${var.this_deployment}storage-1"
		Spawner = "terraform"
		User = var.current_user
		Buildid = "${var.this_deployment}centos-7"
	}
}

resource "aws_ebs_volume" "ssd_vgartesca_storage-1" {
  availability_zone = "${var.region}a"
  size   = var.ssd_vgartesca
  type   = "gp3"  # Use SSD based disks for better performance
    
  tags = {
    Name = "${var.this_deployment}-vgartesca"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "pme_dummyartecentos-7"
  } 
}   
    
resource "aws_volume_attachment" "ssd_vgartesca_storage-1_1" {
  device_name = "/dev/xvd${var.disk_name_mapping[100]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.ssd_vgartesca_storage-1.id}"
  force_detach = true
}


resource "aws_ebs_volume" "ssd_vgos_storage-1" {
  availability_zone = "${var.region}a"
  size   = var.ssd_vgos
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}-vgartesca"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "pme_dummyartecentos-7"
  } 
}
    
resource "aws_volume_attachment" "ssd_vgos_storage-1_1" {
  device_name = "/dev/xvd${var.disk_name_mapping[99]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.ssd_vgos_storage-1.id}"
  force_detach = true
} 

##Begin list of  disk for server storage-1
resource "aws_ebs_volume" "hdd_volume_storage-1_1" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_1"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_1" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_1
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[1]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_1.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_2" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_2"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_2" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_2
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[2]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_2.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_3" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_3"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_3" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_3
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[3]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_3.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_4" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_4"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_4" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_4
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[4]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_4.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_5" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_5"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_5" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_5
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[5]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_5.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_6" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_6"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_6" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_6
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[6]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_6.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_7" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_7"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_7" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_7
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[7]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_7.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_8" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_8"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_8" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_8
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[8]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_8.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_9" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_9"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_9" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_9
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[9]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_9.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_10" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_10"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_10" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_10
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[10]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_10.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_11" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_11"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_11" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_11
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[11]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_11.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-1_12" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-1_hdd_12"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-1_12" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-1_12
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[12]}"
  instance_id  = "${aws_instance.storage-1.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-1_12.id}"
  force_detach = true

}
##End of   disk for server storage-1


resource "aws_eip" "bootstrap_eip" {
  instance = "${aws_instance.storage-1.id}"
  vpc = true
}

resource "null_resource" "generate_supervisor_ssh_key" {
  triggers = {
    current_user = var.current_user
    os = var.os
  }
  
  provisioner "local-exec" {
   command = "yes y | ssh-keygen -f /tmp/${var.this_deployment}_ssh_key -C ${var.this_deployment} -t ${var.ssh_key_type} -b 256 -N ''; for EXT in '' .pub; do mv -v /tmp/${var.this_deployment}_ssh_key$EXT ./ssh_key_${var.this_deployment}$EXT; done; chmod 600 ./ssh_key_${var.this_deployment}"
  }
}

output "eip" {
  value = aws_eip.bootstrap_eip
}   
output "var_region" {
  value = var.region
}

output "Bootstrap_ssh" {
  value = "ssh -i ${local.wrkdir}/ssh_key_${var.this_deployment} root@${aws_eip.bootstrap_eip.public_ip}"
}

output "Connect_on_others_node"{
  value = "ssh -i /root/.ssh/ssh_key_${var.this_deployment} <target host>"
}

output "root_password" {
  value = var.root_password
} 

   
