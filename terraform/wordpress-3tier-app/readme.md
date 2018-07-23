# Wordpress Example

This example shows you how to use Terraform to create a a 3-tier application environment for Wordpress.

## What this example installs:

**Networks**

1 VPC

1 Database subnet

1 Web subnet

1 Public subnet

**Other resources**

1 load balancer

1 or more web servers (Ubuntu Xenial)

1 RDS instance (MySQL 5.7)

1 Floating IP from the Symphony edge network

## Before You Begin

Before you can use this Terraform example, you need to:

* First, do some setup tasks within Symphony.

* Then, create a `terraform.tfvars` file that supplies your environment-specific values for various variables.

Each task is described below.


### Symphony setup tasks

Before you can use this Terraform example, you need to do the following tasks within the Symphony GUI:

1. Create a **dedicated VPC-enabled project** for use with Terraform:

    **Menu** > **Account Management** > **Accounts** > select an account > **Create Project** > select existing Symphony edge network for this project

    For more information about using VPC-enabled projects, see link-to-public-doc.
    
2. Create a **Tenant Admin user** that is associated the the project you just created:

    **Menu** > **Account Management*** > **Accounts** > select an account > "Users" > "Create User"
    
    **Projects** field: specify the project you just created
    
    **Account Roles** field: specify **Tenant Admin***
    
3. Get the **access and secret keys for the project**:

    Log in to the Symhony GUI as the Tenant Admin user you just created.
    
    In the upper right corner, click "Hi username" > "Access Keys" > "Create"
    
    Copy both the access key and the secret key (click the copy icon to the right of each key).
    

4. **Upload the image** you will use for your web server(s) into Symphony:

    Use an Ubuntu Xenial cloud image.
    
    Handy URL - https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
    
    To upload the image into Symphony:
    
    **Menu** > **Applications** > **Images** > **Create** > specify URL
    
    
5. Get the **AMI ID** for the image you just uploaded into Symphony:

    **Menu** > **Applications** > **Images**
    
    Click the name of the image you just uploaded and copy the AWS ID value -- it has a format like this:
    
    ami-1b8ecb82893a4d1f9d500ce33d90496c
    
    
### Create `terraform.tfvars`

Use the included `terraform.tfvars.sample` file as a template. For each variable, fill in your environment-specific value.




    
    
