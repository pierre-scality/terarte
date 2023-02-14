echo "Checking cpu info should have all 4 : sse4_1 sse4_2 movbe pclmulqdq"
egrep --color 'sse4_1|sse4_2|movbe|pclmulqdq' /proc/cpuinfo
echo "OK to continue ? (if you have not you may have hectic behaviour)"
read dummy

VGOS=300G
VGART=960G

printf "Disk of %s will be used for VGOS.\nDisk of %s will be used for VGARTESCA.\nModify the variables in the script if not OK.\nAny key to go ahead" $VGOS $VGART
read dummy

echo "Installing needed pkg"
yum -y install --assumeyes lvm2 isomd5sum python36 tmux 

echo "pkg done, continue ?"
read dummy

lsblk
DEV=$(lsblk |grep $VGOS | awk '{print $1}')
DEV=/dev/$DEV
echo "Device for OS exention $DEV, ok ? "
read dummy

pvcreate $DEV
vgcreate vgos $DEV

echo "Creating /srv/scality/releases"
lvcreate -n srv_scality_releases -L 100G vgos
mkfs.xfs /dev/vgos/srv_scality_releases
mkdir -p /srv/scality/releases
echo "/dev/vgos/srv_scality_releases              /srv/scality/releases/             xfs      defaults       0 0" >> /etc/fstab
mount /srv/scality/releases
df | grep /srv/scality/releases

echo "Creating /var/lib/containerd"
lvcreate -n var_lib_containerd -L 100G vgos
mkfs.xfs /dev/vgos/var_lib_containerd
mkdir -p /var/lib/containerd
echo "/dev/vgos/var_lib_containerd              /var/lib/containerd             xfs      defaults       0 0" >> /etc/fstab
mount /var/lib/containerd
df | grep /var/lib/containerd

# We leave /var/log/ as it is

lsblk
DEV=$(lsblk |grep $VGART | awk '{print $1}')
DEV=/dev/$DEV

echo "creating vgartesca on : $DEV, ok ?"
read dummy
pvcreate $DEV
vgcreate vgartesca $DEV

echo "OK ? will do a full upgrade"
read dummy
yum -y upgrade

 
echo "Done"
echo "Here is the lvm config"
pvs 
vgs
lvs

