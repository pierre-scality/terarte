# Introduction
This terraform files let you build a 1 or 3 nodes artesca environement based on rocky AMI.
It works on us-east-1 (tested) and ap-northeast-1. 

To add more regions you just need to get the AMI ressources from latest nillow and update available_images map in common_variables.tf files.

# Pre req
You must be on scality vpn because of sec rules (could work elsewhere with training varialble below)

1- Create terraform cloud key  

ssh-add ssh-keygen -t rsa  -f ~/.ssh/cloud

2- Get you AWS creds and update ENV.sh file.

Go to 1 login -> AWS single sign own -> Choose account -> command line and ... -> copy the keys and past in ENV.sh sample below (included in the git repo)

```shell
export AWS_ACCESS_KEY_ID="XXXX2DELLWB3Y3EYIJEX"
export AWS_SECRET_ACCESS_KEY="nononoiwontellyou/5T8Z5so0ZITa/Q+ipgMvYO6d6cu"
export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEHMaCmV1LW5vcnRoLTEiRzBFAiAq4713lWvm7dTYYvanYt5LfrvZCsX9VeEH+pfpk+lYRQIhAOSx7ImD074RHbXQR7L094LYdmGri+6E9WImHZ9bQ+5vKtQDCPz//////////wEQABoMNjkzOTI5NDg4NTAzIgz/N1ClxzZgbit2HSsqqAP0X6ySgEednoRbxP+les6Ij4D4pekqnTGT9WPtnT2BmizbAmNEwB9BtqFryOMBZfp5StDLFzq++2MfWSvPZkMCFCYmbI+JMZSoT+GpsWMDyoQXPGTdTlZ3Hzvk6etQqTswSAEX+blabloalbo/u+g5og9URx5JQYXZmtKCf2zb5PAdGV89AVQOXTAPwWOi+qNGWxzZWIyUWQgyrAUbHvgyQmgg2L2R8Evtv79aIv/QFuQus0OcvDMSOghXbRqrRCrfAACP0NxiIkVLz89uibG5gxYLdUwjZArfGIlTOxmant23SQZ1TVBvd56oVmS57pk3sMiZZF+BNfbUzG5EtqQ3LBpffAeLhJKKo2AC0r1tJi03gTrBjCqX+VwLMIrxq58GOqYBfivIIwdCyJrqqzJUx39U305DkxbvwlUrB95/KrgKYxEpAb74HN17WhC6SRn3IAFRZyQUjz3EX82CqGNouCXVrHxVkpqUbu+oyHVBg/FKaOwaUCKsP4VQ+7c9peppS7bSR7H1vWSmeblM7oWoWWocAiVRxfDtWBZWSYSh6suWFZyupShhVlmt6F8AdC7Arpcg94GqtHyl5un5nyZthT+fiOIQl55A9w=="

ssh-agent > /tmp/a
. /tmp/a 
ssh-add ~/.ssh/cloud
ssh-add ~/.ssh/id_rsa
ssh-add -l

```


# Config
Edit the variables in variable.tf. 

common_variable.tf are base setting and should not be modified
You could use one of the VPN ip to allow your own ip (replace one of them)

- region

point to your own region

- this_deployment 

It will create this variable to create hostnames 

- Disk size

The disk size for vg volumes must follow documentation.

 1. ssd_vgos         - Size of the disk to receive vgos volumes
 * ssd_artesca      - Size of the disk to receive vgartesca volumes
 * disk_storage     - Size of storage disks

--

- training 

if you set it to 1 it will allow access from everywhere


# Scripts
The script directory will be copied over. It contains utilities to build artesca.
You can create a scripts directory in your build dir and it will be copied over the bootstrap root dir during install.

# Number of servers
There is a bootstrap.tf that define the bootstrap node and storage-2 and storage-3 for 3 nodes cluster.
If you want a single storage just move storage-2.tf to storage-2.off and same for storage-3. 
Move the 3nodes.tf as well that summarise the 3 nodes ip.
If you don't need a LB move lb.ft as well (for now it is just creating a VM with eip)
Teraform will ignore them

# Build
You need to be on a scality vpn to run the build (EU/JP US not teted) 
```shell
terraform validate
terraform plan -out <yourplan>.plan to write down the base configuration 
terraform apply <yourplan>.plan
```
If the build fails and you try to restart with same plan it will probably through an error of stale state. In this case try terraform refresh. If it doesn't work you can remove the tfstate and relaunch TF, it will destroy/recreate the ressources.


# Access 
Once the build is done it will create an ssh key in the build dir that you can use to access the server
The cli will be displayed at the end of the build
If you build multiple servers you can use the ssh keys from the bootstrap to connect on other hosts (see terraform output as well)

# Artesca scripts
In script/artesca you have helpers to build the cluster, run in order.

- artesca.bootstrap : run on the bootstrap node 1 time. Add base pkg and create pki files.

- artesca.sh : run on all nodes after changing VGOS and VGART variables to match you env.

- artesca.download : It will download and prepare installer change the variables VERSION (artesca version) and USER (user to access packages)




# Disk configuration 
terraform is a description language not very flexible.
Default configuration is 1 artesca disk and 12 HDD (all same disk type gp2 seen as nvme)
Disk mapping are hardcoded in variables (common_variables.tf). There is a max number of disks which is 14
The list is configurable of course. 100 is reserved for vgartesca
There is a script called generatehdd.sh that can generate the disk TF code but you'll have to modify TF files manually with the output

# Restart the installation
Destroy the current deployement (terraform destroy)
Remove the ssh keys, plan file and tfstate*
Redo the 3rd build step
