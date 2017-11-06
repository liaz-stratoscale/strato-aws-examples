import boto3
import botocore
import sys
import os


def main():

    # Replace following parameters with your IP and credentials
    CLUSTER_IP = '10.16.145.239'
    AWS_ACCESS = '13ea32aa83474e6cb3493c9ac1b06d00'
    AWS_SECRET = 'b87335b3b75642c39a59060341e802ae'

    # Example params
    VPC_CIDR = '172.20.0.0/16'
    SUBNET_CIDR = '172.20.10.0/24'
    PORT_INTERNAL = '9080'
    PORT_EXTERNAL = '80'

    """
    This script shows and example of Boto3 ELB v2 integration with Stratoscale Symphony.

    The scenario:
         1. Create VPC
         2. Create Subnet
         3. Create Internet-Gateway
         4. Attach Internet-Gateway
         5. Create Security-Group
         6. Run target instances
         7. List load-balancers
         8. Create load-balancer
         9. Create target-group
         10. Register instances to target-group
         11. Create Listener
         12. Describe the Load-Balancer
    
    This example was tested on versions:
    - botocore 1.7.35
    - boto3 1.4.7
    """

    print ("Disabling warning for Insecure connection")
    botocore.vendored.requests.packages.urllib3.disable_warnings(
        botocore.vendored.requests.packages.urllib3.exceptions.InsecureRequestWarning)

    # creating a EC2 client connection to Symphony AWS Compatible region
    ec2_client = boto3.client(service_name="ec2", region_name="symphony",
                              endpoint_url="https://%s/api/v2/ec2/" % CLUSTER_IP,
                              verify=False,
                              aws_access_key_id = AWS_ACCESS,
                              aws_secret_access_key=AWS_SECRET)

    # creating a ELB client connection to Symphony AWS Compatible region
    elb_client = boto3.client(service_name="elbv2", region_name="symphony",
                              endpoint_url="https://%s/api/v2/aws/elb" % CLUSTER_IP,
                              verify=False,
                              aws_access_key_id = AWS_ACCESS,
                              aws_secret_access_key=AWS_SECRET)

    import ipdb; ipdb.set_trace()
    # Create VPC
    create_vpc_response = ec2_client.create_vpc(CidrBlock=VPC_CIDR)

    # check create vpc returned successfully
    if create_vpc_response['ResponseMetadata']['HTTPStatusCode'] == 200:
        vpcId = create_vpc_response['Vpc']['VpcId']
        print("Created VPC with ID %s" % vpcId)
    else:
        print("Create VPC failed")

    #Create Subnet
    create_subnet_response = ec2_client.create_subnet(CidrBlock=SUBNET_CIDR, VpcId=create_vpc_response['Vpc']['VpcId'])

    # check create subnet returned successfully
    if create_subnet_response['ResponseMetadata']['HTTPStatusCode'] == 200:
        subnetId = create_subnet_response['Subnet']['SubnetId']
        print("Created Subnet with ID %s" % subnetId)
    else:
        print("Create S failed")

    def my_list_lbs():
        # list lbs
        import ipdb; ipdb.set_trace()
        lbs_list_response = client.describe_load_balancers()

        # check lbs list returned successfully
        if lbs_list_response['ResponseMetadata']['HTTPStatusCode'] == 200:
            print ("LBs list: " + ' '.join(p for p in [lb['Name']
                                           for lb in lbs_list_response['LoadBalancers']]))
        else:
            print ("List lbs failed")

    my_list_lbs()

    # create lb
    create_lb_response = client.create_lb(Bucket=BUCKET_NAME)

    # check create lb returned successfully
    if create_lb_response['ResponseMetadata']['HTTPStatusCode'] == 200:
        print "Successfully created lb %s" % BUCKET_NAME
    else:
        print ("Create lb failed")

    my_list_lbs()

    for file_to_delete in [TEST_FILE, TEST_FILE_TARGET]:
        try:
            os.remove(file_to_delete)
        except OSError:
            pass

    # Upload file
    with open(TEST_FILE, 'w') as f:
        f.write('Hello world, symphony lb')

    client.upload_file(TEST_FILE, BUCKET_NAME, TEST_FILE_KEY)
    print "Uploading file %s to lb %s" % (TEST_FILE, BUCKET_NAME)

    # download file
    client.download_file(BUCKET_NAME, TEST_FILE_KEY, '/tmp/file-from-lb.txt')
    print "Downloading object %s from lb %s" % (TEST_FILE_KEY, BUCKET_NAME)

    #delete object in lb
    delete_object_response = client.delete_object(Bucket=BUCKET_NAME, Key=TEST_FILE_KEY)

    if delete_object_response['ResponseMetadata']['HTTPStatusCode'] == 204:
        print "Successfully deleted object %s from lb %s" % (TEST_FILE_KEY, BUCKET_NAME)
    else:
        print ("Download file failed")

    # delete lb
    delete_lb_response = client.delete_lb(Bucket=BUCKET_NAME)

    # check delete lb returned successfully
    if delete_lb_response['ResponseMetadata']['HTTPStatusCode'] == 204:
        print "Successfully delete lb %s" % BUCKET_NAME
    else:
        print ("Delete lb failed")

if __name__ == '__main__':
    sys.exit(main())
