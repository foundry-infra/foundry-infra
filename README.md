# what is the problem this project solves?

Running a secure, private cloud on kubernetes should be easy. 

Requirements:
- low cost
- kubernetes, terraform, vault
- minimal external secrets required

Anti-requirements:
- high availability
- advanced traffic routing and shaping
- high security


# storage backbone

The primary platform data includes:
- tfstates
- secrets (vault backend)

These needs can be met by the highly available object storage solution (e.g. DO Spaces). All terraform states go into one bucket that is the seed bucket. Use nested directories to separate state. Vault can technically live in the same bucket. 

## seed

The initial seed of this infrastructure is the manual creation of the storage of the control plane bucket that will contain state for all additional buckets. 

## all the buckets

All buckets will be managed in terraform, and will be a hard dependency in some way. This includes terraform state files and vault secrets.

# Components

Each component has a dedicated state stored in the main state bucket. This means each component needs the S3 access key and secret for the bucket, in addition to an personal access token for managing other resources. 

## platform-k8s

`platform-k8s` creates the kubernetes cluster.

## platform-vault

`platform-vault` installs vault in the kubernetes cluster.
 
# service infrastructure 

In this approach, all workloads deploy and all network rules apply to one service infrastructure runtime: kubernetes. 

`k8s` cluster is single-point-of-failure for availability and security.

The cluster is provisioned with dedicated tfstate and is a hard data dependency in applications.

# the secret store

Vault runs on kubernetes and is deployed with dedicated tfstate and is a hard data dependency in applications. 

# applications

applications run in dedicated namespace tfstates. The k8s cluster and the vault store are always prerequisites to these modules.

