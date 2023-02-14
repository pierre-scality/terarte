variable "region" {
    default = "ap-northeast-1"  # Tokyo
}

variable "instance_size" {
    type = map
    default = {
        "storage" = "t3.2xlarge"
        "connector" = "t3.small"
    }
}

# If training = 1 it will allow access from all IP
variable "training" {
  default = 0
}

# This one will be used to create hostname 
# Artesca complins if if you use _ use - and others not suported by RFC
variable "this_deployment" {
  default = "pme-art1"
}

variable "disk_os" {
  description = "What is the size for the OS disk (/ /boot ..)"
  default     = 50
}

variable "disk_storage" {
  description = "How big the storage disks (spinners) should be in GB (10 is fine)?"
  default     = 11
}

variable "ssd_vgartesca" {
  description = "How big the storage SSDs should be in GB (10 is fine)?"
  default     = 800
}

variable "ssd_vgos" {
  description = "How big the storage SSDs should be in GB (10 is fine)?"
  default     = 500
}
