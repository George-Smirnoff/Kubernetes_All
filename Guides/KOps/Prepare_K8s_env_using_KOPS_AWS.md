# Prepare K8s env using KOPS

Prerequesites:
1) Download kops binary and grant permition:
```
    curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
    chmod +x kops-linux-amd64
    sudo mv kops-linux-amd64 /usr/local/bin/kops
    kops version
```

2) IAM user: Since kops would create and build several AWS service components together for you, you must have an IAM user with kops required permissions. We have created an IAM user named chap6 in the previous section that has the following policies with the necessary permissions for kops:

- AmazonEC2FullAccess 
- AmazonRoute53FullAccess 
- AmazonS3FullAccess 
- IAMFullAccess 
- AmazonVPCFullAccess

Then, exposing the AWS access key ID and secret key as environment variables can make this role applied on host while firing kops commands:
```
    export AWS_ACCESS_KEY_ID=${string of 20 capital character combination}
    export AWS_SECRET_ACCESS_KEY=${string of 40 character and number combination}
```
OR attach the role on KOPS Bastion instance

3) Prepare an S3 bucket for storing cluster configuration: In our demonstration later, the S3 bucket name will be kubernetes-cookbook.
4) Prepare a Route53 DNS domain for accessing points of cluster: In our demonstration later, the domain name we use will be  private DNS zone "wkfusion.com".


# Export kops state path as Env var
```
export KOPS_STATE_STORE=s3://kops-bucket-ferda234
```

# Run command to create private cluster without bastion host
```
    kops create cluster --name my-kops-cluster.wkfusion.com --state=s3://kops-bucket-ferda234 --zones eu-central-1c --cloud aws --network-cidr 10.10.0.0/16 --master-size t2.large --node-size t2.medium --node-count 2 --networking calico --topology private --dns private --dns-zone wkfusion.com --ssh-public-key ~/.ssh/EU_Frankfurt.pub --bastion false --yes
```

# Run command to create public cluster
```
    kops create cluster --name my-kops-cluster.wfko-10056.workfusion.com --state=s3://kops-bucket-ferda234 --zones eu-central-1c --cloud aws --network-cidr 10.10.0.0/16 --master-size t2.large --node-size t2.medium --node-count 2 --networking calico --topology public --dns public --dns-zone wfko-10056.workfusion.com --ssh-public-key ~/.ssh/EU_Frankfurt.pub --yes
```

`The command "kops create cluster" automatically create the kube config in ~/.kube/config folder`

We can install the kubectl on the same server to start to manage the cluster:
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl get nodes
```


# Run command to delete
```
    kops delete cluster --name my-kops-cluster.wfko-10056.workfusion.com  --state=s3://kops-bucket-ferda234 --yes
```

# Get instancegroups or kops get ig
```
 kops get instancegroups
 ```

# Validate cluster
 #
 ```
 kops validate cluster
```
# To change nodes instance type/number:
```
kops edit instancegroups nodes --name my-kops-cluster.wkfusion.com
kops update cluster --name my-kops-cluster.wkfusion.com --yes
```

# To update bastions autoscaling group
```
kops edit instancegroups bastions --name my-kops-cluster.wkfusion.com
kops update cluster --name my-kops-cluster.wkfusion.com --yes
```

# To update Master autoscaling group
```
kops edit instancegroups master-eu-central-1c --name my-kops-cluster.wkfusion.com
kops update cluster --name my-kops-cluster.wkfusion.com --yes
```
Updating masters is the same as updating nodes. Note that masters in the same availability zone are in one instance group. This means that you can't add additional subnets into the master instance group.<br>
In the real world, the recommended way is to deploy masters to at least two availability zones and have three masters per zone (one kops instance group). You can achieve that via the --master-count and --master-zones parameters when launching the cluster.


