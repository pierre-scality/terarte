#!/bin/bash


BUILDID='${var.this_deployment}centos-7'
STORAGEID=storage-1

NBDISK=12
if [ $# -ne 0 ]; then
  NBDISK=$1
fi

if [ $# -eq 2 ]; then
  STORAGEID=$2
fi



printf "##Begin list of %s disk for server $STORAGEID\n" $D

for NB in $(seq 1 $NBDISK) ; do
cat << fin
resource "aws_ebs_volume" "hdd_volume_${STORAGEID}_$NB" {
  availability_zone = "\${var.region}a"
  size   = var.disk_storage
  type   = "gp2"  # Use SSD based disks for better performance

  tags = {
    Name = "\${var.this_deployment}${STORAGEID}_hdd_${NB}"
    Spawner = "terraform"
    User = var.current_user
    Buildid = "$BUILDID"
  }
}

resource "aws_volume_attachment" "hdd_volume_${STORAGEID}_$NB" {
  depends_on = [
    aws_eip.bootstrap_eip,
    aws_ebs_volume.hdd_volume_${STORAGEID}_$NB
  ]

  device_name = "/dev/xvd\${var.disk_name_mapping[$NB]}"
  instance_id  = "\${aws_instance.$STORAGEID.id}"
  volume_id    = "\${aws_ebs_volume.hdd_volume_${STORAGEID}_$NB.id}"
  force_detach = true

}
fin
done
printf "##End of  %s disk for server $STORAGEID\n" $D
