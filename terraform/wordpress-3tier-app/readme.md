# Wordpress Example

This example shows you how to use Terraform to create a 3-tier application environment for Wordpress.

## What this example deploys

**Networks**

1 VPC

1 Database subnet

1 Web subnet

1 Public subnet

**Other resources**

1 load balancer

2 or more web servers (Ubuntu Xenial)

1 RDS instance (MySQL 5.7)

1 elastic IP from the Symphony edge network

## Before you begin

Before you can use this Terraform example, you need to:

* First, do some setup tasks within Symphony.

* Then, edit the sample `terraform.tfvars` file to specify your environment-specific values for various variables.

Each task is described below.


### Before you begin: Symphony setup tasks

Before you can use this Terraform example, you need to do the following tasks within the Symphony GUI:

1. Make sure you have used Symphony to:

    * Create a VPC-enabled project

    * Obtain access and secret keys for that project

    For information on how to do these tasks, click [here](../README.md) 

2. **Upload the image** you will use for your web server(s) into Symphony:

    Use the Ubuntu Xenial cloud image at this URL:
    
    https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
    
    To upload the image into Symphony:
    
    **Menu** > **Applications** > **Images** > **Create** > specify URL
    
    
3. Get the **AMI ID** for the image you just uploaded into Symphony:

    **Menu** > **Applications** > **Images**
    
    Click the name of the image you just uploaded and copy the AWS ID value -- it has a format like this:
    
    ami-1b8ecb82893a4d1f9d500ce33d90496c
    
4. Enable load balancing:

    **Menu** > **Region Management** > **Settings** > **Services & Support** > click Load Balancing toggle to ON.
    
5. Enable and initialize RDS using a MySQL 5.7 engine:

    **Menu** > **Region Management** > **Settings** > **Services & Support** > click Database toggle to ON.
    
    
### Before you begin: edit `terraform.tfvars`

Use the included `terraform.tfvars` file as a template. For each variable, fill in your environment-specific value, as described below:

**Basic variables**

The following variables: `symphony_ip`, `symp_access_key`, `symp_secret_key` are described [here](../ec2-instance/README.md).


**web_number**

Number of web servers (load balancer will automatically manage target groups).

**web_ami**

The AMI ID for the Xenial image you jsut uploaded into Symphony. It has a format like this:
    
ami-1b8ecb82893a4d1f9d500ce33d90496c

**web_instance_type**

The instance type you want to use for your web server(s). Example: t2.medium

**public_keypair_path**

The path to the public key file that Terraform will pass to Symhpony for authentication.

Background: You can generate a kepair using a tool such as `ssh-keygen`. Place the public and private keys on the machine on which you are running Terraform, for example:

/path/to/myKey.pub

/path/to/myKey.pem

In this example, you would set the `public_keypair_path` to `/path/to/myKey.pub`.


## How to use

1. Get the most recent version of Terraform.

2. Run `terraform init`.

2. Run `terraform apply`


    
    
