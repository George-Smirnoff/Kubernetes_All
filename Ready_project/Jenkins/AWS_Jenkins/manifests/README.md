if you created this cluster with kops, you need to add tag to grant the permission to attach EBS volume that already exist.
You can do it with awscli:
```
aws ec2 create-volume --size 10 --region eu-central-1 --availability-zone eu-central-1a --volume-type gp2 --tag-specifications 'ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=<clustername-here>}]'

For example:
aws ec2 create-volume --size 10 --region eu-central-1 --availability-zone eu-central-1a --volume-type gp2 --tag-specifications 'ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=my-kops-cluster.wfko-10056.workfusion.com}]'
```

or you can do it manually through AWS Console in EC2 -> Volumes -> Your volume -> Tags

`The right cluster name can be found within EC2 instances tags which are part of cluster. Key is the same: KubernetesCluster.` 
