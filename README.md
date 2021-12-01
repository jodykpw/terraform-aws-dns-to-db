# Terraform DNS to DB Demo on AWS with EC2

Example from my udemy enroll course:
[Udemy: Terraform on AWS with SRE & IaC DevOps | Real-World 20 Demos](https://www.udemy.com/course/terraform-on-aws-with-sre-iac-devops-real-world-demos/)

How to create a DNS to DB Demo on AWS with Route53, ALB, EC2 and RDS Database with 3 Applications

![image](https://drive.google.com/uc?export=view&id=15nXqcJcglfJ3g-B30X8SGrTnGyVN9sdQ)

## Pre-requisite

- You need a Registered Domain in AWS Route53 to implement this usecase
- Create `private-key` folder
- Copy your AWS EC2 Key pair `terraform-key.pem` in `private-key` folder

## Populating Variables

The values for these variables should be placed into terraform.tfvars. Simply copy terraform.tfvars.example to terraform.tfvars and edit it with the proper values.

## Create secrets.tfvars

```t
db_password = "dbpassword11"
```

## Execute Terraform Commands

terraform init

terraform validate

terraform plan -var-file="secrets.tfvars"

terraform apply -var-file="secrets.tfvars"

## Verify via AWS Management Console

Observation:

1. Verify EC2 Instances created
2. Verify VPC
3. Verify Subnets
4. Verify IGW
5. Verify Public Route for Public Subnets
6. Verify no public route for private subnets
7. Verify NAT Gateway and Elastic IP for NAT Gateway
8. Verify NAT Gateway route for Private Subnets
9. Verify no public route or no NAT Gateway route to Database Subnets
10. Verify Subnets Security Group
11. Verify Load Balancer Security Group (80 and SSL 443 Rule)
12. Verify ALB Listener - HTTP:80 - Should contain a redirect from HTTP to HTTPS
13. Verify ALB Listener - HTTPS:443

```t
13.1. /app1* to app1 target group
13.2. /app2* to app2 target group
13.3. /* to app3 target group
```

14. Verify ALB Target Groups App1, App2 and App3, Targets (should be healthy)
15. Verify SSL Certificate (Certificate Manager)
16. Verify Route53 DNS Record
17. Verify Tags

## Connect to Bastion EC2 Instance and Test

```t
# Connect to Bastion EC2 Instance from local desktop
ssh -i private-key/terraform-key.pem ec2-user@<PUBLIC_IP_FOR_BASTION_HOST>

# Curl Test for Bastion EC2 Instance to Private EC2 Instances
curl  http://<Private-Instance-App1-Private-IP>
curl  http://<Private-Instance-App2-Private-IP>
curl  http://<Private-Instance-App3-Private-IP>

# Connect to Private EC2 Instances App 1 from Bastion EC2 Instance
ssh -i /tmp/terraform-key.pem ec2-user@<Private-Instance-App1-Private-IP>
cd /var/www/html
ls -lrta
Observation: 
1) Should find index.html
2) Should find app1 folder
3) Should find app1/index.html file
4) Should find app1/metadata.html file

# Connect to Private EC2 Instances App 2 from Bastion EC2 Instance
ssh -i /tmp/terraform-key.pem ec2-user@<Private-Instance-App2-Private-IP>
cd /var/www/html
ls -lrta
Observation: 
1) Should find index.html
2) Should find app2 folder
3) Should find app2/index.html file
4) Should find app2/metadata.html file

# Connect to App3 EC2 Instance from Jumpbox
ssh -i /tmp/terraform-key.pem ec2-user@<App3-Ec2Instance-1-Private-IP>

# Check logs
cd app3-usermgmt
more ums-start.log
```

# Access Applications and Test
```t
# App1 
https://apps.domain.com/app1/index.html
http://apps.domain.com/app1/metadata.html

# App2
http://apps.domain.com/app2/index.html
http://apps.domain.com/app2/metadata.html

# App3
http://apps.domain.com
Username: admin101
Password: password101
1. Create a user, List User
2. Verify user in DB
```

## Terraform Destroy

terraform destroy

## Clean-Up

rm -rf .terraform*

rm -rf terraform.tfstate*
