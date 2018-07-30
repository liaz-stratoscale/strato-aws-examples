# Simple EC2 Example

This Terraform example creates a very simple EC2 instance from an AMI stored in Symphony.

## Before you begin

Before you can use this Terraform example, you need to:

* First, do some setup tasks within Symphony.

* Then, create a `terraform.tfvars` file that supplies your environment-specific values for various variables.

Each task is described below.


### Before you begin: Symphony setup tasks

Before you can use this Terraform example, you need to do the following tasks within the Symphony GUI:

1. Create a **dedicated VPC-enabled project** for use with Terraform:

    **Menu** > **Account Management** > **Accounts** > select an account > **Create Project** > select existing Symphony edge network for this project

    For more information about using VPC-enabled projects, see [additional information about using VPC-enabled projects](https://knowledge2.stratoscale.com/display/SYMP/Using+a+VPC-Enabled+Project).
    
2. Create a **Tenant Admin user** that is associated the the project you just created:

    **Menu** > **Account Management*** > **Accounts** > select an account > **Users** > **Create User**
    
    **Projects** field: specify the project you just created
    
    **Account Roles** field: specify **Tenant Admin**
    
3. Get the **access and secret keys for the project**:

    Log in to the Symhony GUI as the Tenant Admin user you just created.
    
    In the upper right corner, click **Hi username** > **Access Keys** > **Create**
    
    Copy both the access key and the secret key (click the copy icon to the right of each key).
    

4. Get the **AMI ID** for the image you want to use for the EC2 instance you are creating:

    **Menu** > **Applications** > **Images**
    
    Click the name of the image you want to use and copy the image's AWS ID value -- it has a format like this:
    
    ami-1b8ecb82893a4d1f9d500ce33d90496c
    
    
### Before you begin: create `terraform.tfvars`

Use the included `terraform.tfvars` file as a template. For each variable, fill in your environment-specific value, as described below:

| Variable        | Description                                 | Required? |
| --------------- | ------------------------------------------- | --------- |
| symphony_ip     | IP of your Symphony region                  | Yes       |
| access_key      | Access key                                  | Yes       |
| secret_key      | Secret key                                  | Yes       |
| ami_image       | AMI ID, for example ami-123456789999999     | Yes       |
| instance_type   | Type of instance, for example t2.medium     | No        |
| instance_number | How many EC2 instances you want to create   | No        |

## How to use

1. Get the most recent version of Terraform.

2. Run `terraform apply`.
