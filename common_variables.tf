################################
# You MAY change these variables

# Set to 1 if you want to generate an offline infra
variable "offline" {
  default = 0
}

# The name of the SSH key in your provider's configuration
variable "ssh_key_name" {
  default = "terraform"
}

# Where this SSH key is stored in the machine
variable "ssh_key_path" {
  default = "~/.ssh/cloud"
}

variable "os" {
  default     = "rocky-8.6"
}

variable "current_user" {
  description = "The current user running Terraform"
  default     = "unknown"
}

# Open the file "variables.tf" in providers folders for the remaining available variables (like the instances size,
# the image IDs or the region)

#######################################
# You SHOULD NOT change these variables

variable "scality_office_ip_colt" {
  default = "173.105.238.42/32"
}

variable "scality_vpn_tk" {
  default = "172.105.238.42/32"
}

variable "scality_office_ip_orange" {
  default = "193.248.60.56/32"
}

variable "scality_vpn_ip" {
  default = "141.94.181.72/32"
}

variable "scality_office_sf_ip" {
  default = "38.142.74.18/32"
}

variable "packages_scality_com_eu_ip_range" {
  default = "188.165.182.64/26"
}

variable "packages_scality_com_us_ip_range" {
  default = "144.217.45.128/25"
}

variable "packages_scality_com_geo_ip_range" {
  default = "5.196.181.52/27"
}

# Commands that need to be run before anything else (mostly requirements)
variable "init_specific_commands" {
  type = map

  default = {
    "centos-7" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-7.latest" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-7.2" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-7.4" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-7.5" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-7.6" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-7.7" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-7.8" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-7.9" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-8" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-8.latest" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "centos-8.2" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "rocky-8" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "rocky-8.5" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "rocky-8.6" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF

    "rocky-8.latest" = <<EOF
sudo bash -c 'echo "ip_resolve=4" >> /etc/yum.conf'  # Make yum use IPv4 addresses only
EOF
  }
}

variable "ssh_key_type" {
  default = "ecdsa"
}

variable "gui_password" {
  default = ""
}

variable "root_password" {
  default = "CFr9Ec5aoRDtPqD8"
}

variable "ssh_pwd_auth" {
  default = "yes"
}

# Setup the root password and prepare the public key authentication
variable "init_ssh" {
  default = <<EOF
echo -e "CFr9Ec5aoRDtPqD8\nCFr9Ec5aoRDtPqD8\n" | sudo passwd root
sudo mkdir -p /root/.ssh
sudo chmod 700 /root/.ssh
sudo sed -ri 's/^#(PermitRootLogin yes)/\1/' /etc/ssh/sshd_config
sudo sed -ri 's/^(PasswordAuthentication) no/\1 yes/' /etc/ssh/sshd_config
EOF
}

variable "reload_ssh" {
  type = map

  default = {
    "centos-7"        = "sudo systemctl reload sshd"
    "centos-7.latest" = "sudo systemctl reload sshd"
    "centos-7.2"      = "sudo systemctl reload sshd"
    "centos-7.4"      = "sudo systemctl reload sshd"
    "centos-7.5"      = "sudo systemctl reload sshd"
    "centos-7.6"      = "sudo systemctl reload sshd"
    "centos-7.7"      = "sudo systemctl reload sshd"
    "centos-7.8"      = "sudo systemctl reload sshd"
    "centos-7.9"      = "sudo systemctl reload sshd"
    "rocky-8"         = "sudo systemctl reload sshd"
    "rocky-8.5"       = "sudo systemctl reload sshd"
    "rocky-8.6"       = "sudo systemctl reload sshd"
    "rocky-8.latest"  = "sudo systemctl reload sshd"
  }
}

variable "disk_name_mapping" {
  type = map

  default = {
    "0"  = "a"
    "1"  = "b"
    "2"  = "c"
    "3"  = "d"
    "4"  = "e"
    "5"  = "f"
    "6"  = "g"
    "7"  = "h"
    "8"  = "i"
    "9"  = "j"
    "10" = "k"
    "11" = "l"
    "12" = "m"
    "13" = "n"
    "14" = "o"
    "99" = "y"
    "100" = "z"
  }

}

variable "available_images" {
    type = map
    default = {
        "us-east-2.centos-7" = "ami-00f8e2c955f7ffa9b",         # AWS market place CentOS 7.9.2009 x86_64
        "us-east-2.rocky-8"  = "ami-048c0301b51b9454e",         # AWS market place RockyLinux-8.6-LVM-20220518-8GiB
        "us-east-2.centos-7.latest" = "ami-00f8e2c955f7ffa9b",  # AWS market place CentOS 7.9.2009 x86_64
        "us-east-2.centos-7.7" = "ami-01e36b7901e884a10",       # AWS market place
        "us-east-2.centos-7.8" = "ami-0a75b786d9a7f8144",       # AWS market place CentOS 7.8.2003 x86_64
        "us-east-2.centos-7.9" = "ami-00f8e2c955f7ffa9b",       # AWS market place CentOS 7.9.2009 x86_64
        "us-east-2.rocky-8.5"  = "ami-01edd6d087dc37816",       # AWS market place RockyLinux-8.5-LVM-20220514-8GiB
        "us-east-2.rocky-8.6"  = "ami-048c0301b51b9454e",       # AWS market place RockyLinux-8.6-LVM-20220518-8GiB
        "us-east-2.rocky-8.latest"  = "ami-048c0301b51b9454e",  # AWS market place RockyLinux-8.6-LVM-20220518-8GiB
        # ========================================
        "eu-west-1.centos-7" = "ami-04f5641b0d178a27a",         # AWS market place CentOS 7.9.2009 x86_64
        "eu-west-1.rocky-8"  = "ami-0f27673e02221beb2",         # AWS market place ProComputers RockyLinux-8.6-x86_64-LVM-8GiB-HVM-20220518_144555-dbd93820-4ed5-4f22-92fa-0071fad10e2b
        "eu-west-1.centos-7.latest" = "ami-04f5641b0d178a27a",  # AWS market place CentOS 7.9.2009 x86_64
        "eu-west-1.centos-7.9" = "ami-04f5641b0d178a27a",       # AWS market place CentOS 7.9.2009 x86_64
        "eu-west-1.rocky-8.6"  = "ami-0f27673e02221beb2",       # AWS market place ProComputers RockyLinux-8.6-x86_64-LVM-8GiB-HVM-20220518_144555-dbd93820-4ed5-4f22-92fa-0071fad10e2b
        "eu-west-1.rocky-8.latest"  = "ami-0f27673e02221beb2",  # AWS market place ProComputers RockyLinux-8.6-x86_64-LVM-8GiB-HVM-20220518_144555-dbd93820-4ed5-4f22-92fa-0071fad10e2b
        # ========================================
        "ap-northeast-1.rocky-9" = "ami-0362c6c38aa902b42",         # AWS market place Rocky Linux.  Rocky-9-EC2-Base-9.1-20221123.0.x86_64
        "ap-northeast-1.rocky-8" = "ami-0c38a5fa7b9dbd96c",       # AWS market place CentOS.  Rocky-8-ec2-8.6-20220515.0.x86_64-d6577ceb-8ea8-4e0e-84c6-f098fc302e82
        "ap-northeast-1.rocky-8.latest" = "ami-0c38a5fa7b9dbd96c",       # AWS market place CentOS.  Rocky-8-ec2-8.6-20220515.0.x86_64-d6577ceb-8ea8-4e0e-84c6-f098fc302e82
        "ap-northeast-1.rocky-8.6" = "ami-0c38a5fa7b9dbd96c",       # AWS market place CentOS.  Rocky-8-ec2-8.6-20220515.0.x86_64-d6577ceb-8ea8-4e0e-84c6-f098fc302e82
        "ap-northeast-1.rocky-8.7" = "ami-0e7fe56f3b75f60b3",       # AWS market place Rocky Linux.  Rocky-8-EC2-8.7-20221112.0.x86_64
        "ap-northeast-1.rocky-9.1" = "ami-0362c6c38aa902b42",       # AWS market place Rocky Linux.  Rocky-9-EC2-Base-9.1-20221123.0.x86_64
        "ap-northeast-1.rocky-9.latest" = "ami-0362c6c38aa902b42",  # AWS market place Rocky Linux.  Rocky-9-EC2-Base-9.1-20221123.0.x86_64

    }
}

variable "remote_user" {
    type = map
    default = {
        "centos-7" = "centos"
        "centos-7.latest" = "centos"
        "centos-7.8" = "centos"
        "centos-7.9" = "centos"
        "rocky-8" = "rocky"
        "rocky-8.latest" = "rocky"
        "rocky-8.5" = "rocky"
        "rocky-8.6" = "rocky"
    }
}
