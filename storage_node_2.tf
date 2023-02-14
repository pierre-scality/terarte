
resource "aws_instance" "storage-2" {
  depends_on = [
    aws_eip.bootstrap_eip,
    null_resource.generate_supervisor_ssh_key
  ]

	ami = lookup(var.available_images, "${var.region}.${var.os}")

	availability_zone = "${var.region}a"  
	instance_type     = lookup(var.instance_size, "storage")
	key_name          = "${var.ssh_key_name}_${var.current_user}"

  vpc_security_group_ids = [aws_security_group.ring.id]
  subnet_id = "${aws_subnet.internal_a.id}" 

	root_block_device {
		volume_type = "gp3"
		volume_size = var.disk_os
		delete_on_termination = true
	}

  connection {
    host = self.private_ip
    type = "ssh"
    user = var.remote_user[var.os]
    bastion_host = aws_eip.bootstrap_eip.public_ip
    private_key = file("${var.ssh_key_path}")
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
		source      = "ssh_key_${var.this_deployment}.pub"
		destination = "/tmp/root_ssh_key.pub"
	}

provisioner "remote-exec" {
  inline = [
    "echo Setting host name ${var.this_deployment}-2",
    "sudo hostnamectl set-hostname ${var.this_deployment}-2",
    "echo Copy root public key to authorized_keys",
    "sudo cp /tmp/root_ssh_key.pub /root/.ssh/authorized_keys",
    "sudo chown root:root /root/.ssh/authorized_keys",
    "sudo chmod 600 /root/.ssh/authorized_keys",

  ]
} 


  tags = {
    Name = "${var.this_deployment}storage-2"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_ebs_volume" "ssd_vgartesca_storage-2" {
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
    
resource "aws_volume_attachment" "ssd_vgartesca_storage-2_1" {
  device_name = "/dev/xvd${var.disk_name_mapping[100]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.ssd_vgartesca_storage-2.id}"
  force_detach = true
} 
    

resource "aws_ebs_volume" "ssd_vgos_storage-2" {
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

resource "aws_volume_attachment" "ssd_vgos_storage-2_1" {
  device_name = "/dev/xvd${var.disk_name_mapping[99]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.ssd_vgos_storage-2.id}"
  force_detach = true 
} 

##Begin list of  disk for server storage-2
resource "aws_ebs_volume" "hdd_volume_storage-2_1" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_1"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_1" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_1
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[1]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_1.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_2" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_2"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_2" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_2
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[2]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_2.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_3" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_3"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_3" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_3
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[3]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_3.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_4" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_4"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_4" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_4
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[4]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_4.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_5" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_5"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_5" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_5
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[5]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_5.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_6" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_6"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_6" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_6
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[6]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_6.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_7" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_7"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_7" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_7
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[7]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_7.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_8" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_8"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_8" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_8
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[8]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_8.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_9" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_9"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_9" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_9
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[9]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_9.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_10" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_10"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_10" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_10
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[10]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_10.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_11" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_11"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_11" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_11
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[11]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_11.id}"
  force_detach = true

}
resource "aws_ebs_volume" "hdd_volume_storage-2_12" {
  availability_zone = "${var.region}a"
  size   = var.disk_storage
  type   = "gp3"  # Use SSD based disks for better performance

  tags = {
    Name = "${var.this_deployment}storage-2_hdd_12"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "${var.this_deployment}centos-7"
  }
}

resource "aws_volume_attachment" "hdd_volume_storage-2_12" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_storage-2_12
  ]

  device_name = "/dev/xvd${var.disk_name_mapping[12]}"
  instance_id  = "${aws_instance.storage-2.id}"
  volume_id    = "${aws_ebs_volume.hdd_volume_storage-2_12.id}"
  force_detach = true

}
##End of   disk for server storage-2


output "private_ip_storage-2" {
  value = aws_instance.storage-2.private_ip
}   

