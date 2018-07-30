# Symphony Terraform Examples

Theses examples show you how to use the Terraform AWS provider with Stratoscale Symphony.

## Before you begin

Before you can use these Terraform examples, you need to:

* First, do some setup tasks within Symphony.

* Then, create a `terraform.tfvars` file that supplies your environment-specific values for various variables.

Each task is described below.


### Before you begin: Symphony setup tasks

Before you can use these Terraform examples, you need to do the following tasks within the Symphony GUI:

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
    

4. **Do any additional tasks** that may be required for whatever specific Terraform examples you plan to use. These tasks are described in the readme files for each example. 

### Before you begin: create `terraform.tfvars`

Each Terraform example includes a sample `terraform.tfvars` file that you can use as a template. For each variable, fill in your environment-specific value.

## How to use

1. Get the most recent version of Terraform.

2. Run `terraform apply`.
