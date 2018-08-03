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
    
    **Menu** > **Database** > **Engines** > MySQL 5.7.00 > toggle **Enabled** switch to ON.
    
    
### Before you begin: edit `terraform.tfvars`

Use the included `terraform.tfvars` file as a template. For each variable, fill in your environment-specific value, as described below:

_Basic variables_

The following variables: **symphony_ip**, **symp_access_key**, **symp_secret_key** are described [here](../ec2-instance/README.md).

_Web server variables_

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

Assume you put the public key file here: `/path/to/myKey.pub`

And you put the private key file here: `/path/to/myKey.pem`

In this example, you would set the `public_keypair_path` variable to `/path/to/myKey.pub`.

**connect_instances_to_web_ip**

Boolean. Controls whether or not you can SSH into the web server instances:

`False`(default) isolates the web servers from SSH access into them.

`True` lets you SSH into the web server instances for troubleshooting or other purposes. For more information, see the _SSH access_ info in the **How to use** section below. 

_Database variables. Note that the Wordpress container uses the Wordpress database by default_

**db_password**

Database password.

**db_user**

Database user.

**db_name**

Database name.


## How to use

1. Get the most recent version of Terraform.

2. Run `terraform init`.

3. Run `terraform apply`. Take a look at the `terraform apply`output and note that it includes the elastic IP (EIP) of the load balancer. Make a note of this load balancer EIP, because you will need it later to access Wordpress.

4. Point your browser to Wordpress at this location:

    `http://<load_balancer_eip>:80`

    Initially, you will see the Wordpress installation and configuration pages.

    **How to get the _<load_balancer_eip>_**:

    * This load balancer EIP was part of the output from `terraform apply`. You can always redisplay that output by running `terraform refresh`.

    * You can also get the load balancer EIP from the Symphony GUI:

        **Menu** > **Load Balancing** > **Load Balancers** > select the load balancer that Terraform just created.

        The field marked **Floating IP** contains the load balancer EIP that you need to access Wordpress.
        
### SSH access to web servers

There may be times when you want to SSH into the web servers that are part of your Wordpress deployment. This can be for troubleshooting or other purposes:

**To SSH into a web server**

Here is a sample scenario:

1. Make sure you know the path to where you stored your private key file on the machine where you are running Terraform, for example:

    `/path/to/myKey.pem`

2. Get the elastic IP (EIP) of the web server instance -- use either `terraform refresh` or the GUI:

    **Menu** > **Compute** > **Intances** > instance name > **Networks** field -- see IP next to that
    
3. In the `terraform.tfvars` file, set `connect_instances_to_web_ip` to `True`. This enables SSH access into web instances.

4. Run `terraform  apply`.

5. SSH into the web server using syntax like this:

    `ssh -i '/path/to/myKey.pem' ubuntu@<eip_of_web_server_instance>`
   
When you no longer need SSH access into the web server, you can reset it like this:

Change `connect_instances_to_wepb_ip` back to `False`.

Run `terraform apply` again.







    
    
