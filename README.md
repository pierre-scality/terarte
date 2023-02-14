# Introduction
This terraform files let you build a 1 or 3 nodes artesca environement based on rocky AMI.
It works on us-east-1 (tested) and could work on eu-west-1. The reason is that various ressources as AMI id are different between regions and need to be hardcoded in TF.

# Pre req
You must be on scality vpn because of sec rules.
Base terraform uses cloud key, create your own and set it up with ssh-add
You need also to set the AWS cred keys.
Use script below to automate this before lauching TF.

```shell
export AWS_ACCESS_KEY_ID=AKIAYKVURKFX7E2DDJ5H
export AWS_SECRET_ACCESS_KEY=<secret key>

ssh-agent > /tmp/a
. /tmp/a 
ssh-add ~/.ssh/cloud
ssh-add ~/.ssh/id_rsa
ssh-add -l

```


# Config
Edit the variables in variable.tf 
Mostly disk size (disk count not dynamic) and depployement name.
The deployement name will define the hostname 
common_variable.tf are base setting and should not be modified
You can create a scripts directory in your build dir and it will be copied over the bootstrap root dir during install.
If you have only on node move the tf file 3nodes.tf to 3nodes.tf.off

# Number of servers 
There is a bootstrap.tf that define the bootstrap node and storage-2 and storage-3 for 3 nodes cluster.
If you want a single storage just move storage-2.tf to storage-2.off and same for storage-3. 
Move the 3nodes.tf as well that summarise the 3 nodes ip.
Teraform will ignore them

# Build
You need to be on a scality vpn to run the build (EU/JP US not teted) 
```shell
terraform validate
terraform plan -out <yourplan>.plan to write down the base configuration 
terraform apply <yourplan>.plan
```

# Access 
Once the build is done it will create an ssh key in the build dir that you can use to access the server
The cli will be displayed at the end of the build
If you build multiple servers you can use the ssh keys from the bootstrap to connect on other hosts (see terraform output as well)

# Disk configuration 
terraform is a description language not very flexible.
Default configuration is 1 artesca disk and 12 HDD (all same disk type gp2 seen as nvme)
Disk mapping are hardcoded in variables. There is a max number of disks which is 14
The list is configurable of course. 100 is reserved for vgartesca
There is a script called generatehdd.sh that can generate the disk TF code but you'll have to modify TF files manually with the output

# Restart the installation
Destroy the current deployement (terraform destroy)
Remove the ssh keys and the plan file
Redo the 3rd build step
