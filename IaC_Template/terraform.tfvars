address= "http://127.0.0.1:8200" # The address of the vault provider in the provider.tf file

backend = "aws" #backend attribute for the vault_aws_access_credentials in the provider.tf file

role = "terraform-role" #role attribute for the vault_aws_access_credentials in the provider.tf file

region = "eu-north-1"
# NOTE: EC2p5 (instance_type) instances does only exist in those regions [Europe (Stockholm) — eu-north-1, Asia Pacific (Tokyo) — ap-northeast-1, US West (Oregon) — us-west-2, US East (Ohio) — us-east-2, US East (N. Virginia) — us-east-1]
# NOTE: EC2pe5 (instance_type) instances does only exists in the "US East (Ohio) — us-east-2" region

environment = "Production" # Environment on witch we are deploying the Infrastructure.

vpc_cidr_block = "10.0.0.0/16" # The CIDR block for your VPC

vpc_name = "main-vpc"  # The name of your VPC

availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"] # changing the number of AZ will result in an error 

instance_number = 3 #Specify your desired number of instances as integer

instance_type = "p5.48xlarge" # customize to the instance type you want to use and keep in mind the region depandency.

ami_id = "ami-0baf6d499ec1a6988" # Replace with your AMI_Id (the template image you want to clone from).

# NOTE s3_life_cycle is Enabled, that mean that the data will be deleted after 1 year

storage_users_ip_addresses = ["192.168.1.16"] # ADD users machines IP addresses that need to Access the S3 bucket and FSx for Luster (full access CRUD)

fsx_storage_capacity = 1200 # Set the desired amount of storage for the fsx for Luster. 
