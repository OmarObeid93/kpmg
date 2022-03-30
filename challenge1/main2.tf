provider "aws" {
	region="us-east-1"
}

resource "aws_eip" "natgweip" {
  id = eipalloc-09d16ef368f268b1d
  association_id = eipassoc-0d109e75a77888f3f
  customer_owned_ip = 
  customer_owned_ipv4_pool = 
  domain = vpc
  instance = 
  network_interface = eni-0e87d6739e069a3e3
  private_dns = ip-10-0-2-109.ec2.internal
  private_ip = 10.0.2.109
  public_dns = ec2-54-86-145-237.compute-1.amazonaws.com
  public_ip = 54.86.145.237
  public_ipv4_pool = amazon
  tags.% = 0
  vpc = true
}
resource "aws_nat_gateway" "natgw" {
  id = nat-0c7f9dbfe87f228f1
  allocation_id = eipalloc-09d16ef368f268b1d
  network_interface_id = eni-0e87d6739e069a3e3
  private_ip = 10.0.2.109
  public_ip = 54.86.145.237
  subnet_id = subnet-02533b3ca601f2214
  tags.% = 1
  tags.Name = kpmg-natGateway
}
resource "aws_internet_gateway" "gw" {
  id = igw-0d08e9caf9907fc66
  arn = arn:aws:ec2:us-east-1:193178401758:internet-gateway/igw-0d08e9caf9907fc66
  owner_id = 193178401758
  tags.% = 1
  tags.Name = kpmg-IG
  vpc_id = vpc-0ededcb9275dc19f9
}

#route tables

# Public
resource "aws_route_table" "public" {
  id = rtb-01fe789955a8b65fa
  owner_id = 193178401758
  propagating_vgws.# = 0
  route.# = 1
  route.3397256160.cidr_block = 0.0.0.0/0
  route.3397256160.egress_only_gateway_id = 
  route.3397256160.gateway_id = igw-0d08e9caf9907fc66
  route.3397256160.instance_id = 
  route.3397256160.ipv6_cidr_block = 
  route.3397256160.nat_gateway_id = 
  route.3397256160.network_interface_id = 
  route.3397256160.transit_gateway_id = 
  route.3397256160.vpc_peering_connection_id = 
  tags.% = 1
  tags.Name = kpmg-public-RT
  vpc_id = vpc-0ededcb9275dc19f9
}
resource "aws_route_table_association" "public1" {
  id = rtbassoc-0b9fc361f4b53503e
  route_table_id = rtb-01fe789955a8b65fa
  subnet_id = subnet-0b37abce35e95f9e7
}
resource "aws_route_table_association" "public2" {
  id = rtbassoc-0d5b1a7784dfc22e9
  route_table_id = rtb-01fe789955a8b65fa
  subnet_id = subnet-02533b3ca601f2214
}

# Private
resource "aws_route_table" "private" {
  id = rtb-0e5c32fdb1fc5e7a2
  owner_id = 193178401758
  propagating_vgws.# = 0
  route.# = 1
  route.328076273.cidr_block = 0.0.0.0/0
  route.328076273.egress_only_gateway_id = 
  route.328076273.gateway_id = 
  route.328076273.instance_id = 
  route.328076273.ipv6_cidr_block = 
  route.328076273.nat_gateway_id = nat-0c7f9dbfe87f228f1
  route.328076273.network_interface_id = 
  route.328076273.transit_gateway_id = 
  route.328076273.vpc_peering_connection_id = 
  tags.% = 1
  tags.Name = kpmg-private-RT
  vpc_id = vpc-0ededcb9275dc19f9
}
resource "aws_route_table_association" "private3" {
  id = rtbassoc-08289147c9ee4822b
  route_table_id = rtb-0e5c32fdb1fc5e7a2
  subnet_id = subnet-099f3a7785cd489f4
}
resource "aws_route_table_association" "private4" {
  id = rtbassoc-0185a99823d016178
  route_table_id = rtb-0e5c32fdb1fc5e7a2
  subnet_id = subnet-0b750e958bdc96bd2
}

# Bastion
resource "aws_security_group" "bastion_ssh_all_sg_darwin" {
  id = sg-0e79dd50a5ddfa790
  arn = arn:aws:ec2:us-east-1:193178401758:security-group/sg-0e79dd50a5ddfa790
  description = launch-wizard-1 created 2022-03-29T06:50:44.781+03:00
  egress.# = 1
  egress.482069346.cidr_blocks.# = 1
  egress.482069346.cidr_blocks.0 = 0.0.0.0/0
  egress.482069346.description = 
  egress.482069346.from_port = 0
  egress.482069346.ipv6_cidr_blocks.# = 0
  egress.482069346.prefix_list_ids.# = 0
  egress.482069346.protocol = -1
  egress.482069346.security_groups.# = 0
  egress.482069346.self = false
  egress.482069346.to_port = 0
  ingress.# = 1
  ingress.2541437006.cidr_blocks.# = 1
  ingress.2541437006.cidr_blocks.0 = 0.0.0.0/0
  ingress.2541437006.description = 
  ingress.2541437006.from_port = 22
  ingress.2541437006.ipv6_cidr_blocks.# = 0
  ingress.2541437006.prefix_list_ids.# = 0
  ingress.2541437006.protocol = tcp
  ingress.2541437006.security_groups.# = 0
  ingress.2541437006.self = false
  ingress.2541437006.to_port = 22
  name = launch-wizard-1
  owner_id = 193178401758
  tags.% = 0
  vpc_id = vpc-0ededcb9275dc19f9
}

# External Application Load Balancer
resource "aws_security_group" "external_alb_sg" {
  id = sg-0441ae5390392e4c6
  arn = arn:aws:ec2:us-east-1:193178401758:security-group/sg-0441ae5390392e4c6
  description = Allow HTTP and HTTPS
  egress.# = 1
  egress.482069346.cidr_blocks.# = 1
  egress.482069346.cidr_blocks.0 = 0.0.0.0/0
  egress.482069346.description = 
  egress.482069346.from_port = 0
  egress.482069346.ipv6_cidr_blocks.# = 0
  egress.482069346.prefix_list_ids.# = 0
  egress.482069346.protocol = -1
  egress.482069346.security_groups.# = 0
  egress.482069346.self = false
  egress.482069346.to_port = 0
  ingress.# = 2
  ingress.2214680975.cidr_blocks.# = 1
  ingress.2214680975.cidr_blocks.0 = 0.0.0.0/0
  ingress.2214680975.description = 
  ingress.2214680975.from_port = 80
  ingress.2214680975.ipv6_cidr_blocks.# = 0
  ingress.2214680975.prefix_list_ids.# = 0
  ingress.2214680975.protocol = tcp
  ingress.2214680975.security_groups.# = 0
  ingress.2214680975.self = false
  ingress.2214680975.to_port = 80
  ingress.2617001939.cidr_blocks.# = 1
  ingress.2617001939.cidr_blocks.0 = 0.0.0.0/0
  ingress.2617001939.description = 
  ingress.2617001939.from_port = 443
  ingress.2617001939.ipv6_cidr_blocks.# = 0
  ingress.2617001939.prefix_list_ids.# = 0
  ingress.2617001939.protocol = tcp
  ingress.2617001939.security_groups.# = 0
  ingress.2617001939.self = false
  ingress.2617001939.to_port = 443
  name = kpmg-AutoScaling-SecurityGroup
  owner_id = 193178401758
  tags.% = 0
  vpc_id = vpc-0ededcb9275dc19f9
}

# Internal Application Load Balancer
resource "aws_security_group" "internal_alb_sg" {
  id = sg-0ddc0797e7657bfd7
  arn = arn:aws:ec2:us-east-1:193178401758:security-group/sg-0ddc0797e7657bfd7
  description = Allow port 3000
  egress.# = 1
  egress.482069346.cidr_blocks.# = 1
  egress.482069346.cidr_blocks.0 = 0.0.0.0/0
  egress.482069346.description = 
  egress.482069346.from_port = 0
  egress.482069346.ipv6_cidr_blocks.# = 0
  egress.482069346.prefix_list_ids.# = 0
  egress.482069346.protocol = -1
  egress.482069346.security_groups.# = 0
  egress.482069346.self = false
  egress.482069346.to_port = 0
  ingress.# = 1
  ingress.1994621032.cidr_blocks.# = 1
  ingress.1994621032.cidr_blocks.0 = 0.0.0.0/0
  ingress.1994621032.description = 
  ingress.1994621032.from_port = 3000
  ingress.1994621032.ipv6_cidr_blocks.# = 0
  ingress.1994621032.prefix_list_ids.# = 0
  ingress.1994621032.protocol = tcp
  ingress.1994621032.security_groups.# = 0
  ingress.1994621032.self = false
  ingress.1994621032.to_port = 3000
  name = kpmg-AutoScaling-SecurityGroup-BE
  owner_id = 193178401758
  tags.% = 0
  vpc_id = vpc-0ededcb9275dc19f9
}

# Additional SG for Launch Configuration
resource "aws_security_group" "web_outbound_sg" {
  id = sg-0e79dd50a5ddfa790
  arn = arn:aws:ec2:us-east-1:193178401758:security-group/sg-0e79dd50a5ddfa790
  description = launch-wizard-1 created 2022-03-29T06:50:44.781+03:00
  egress.# = 1
  egress.482069346.cidr_blocks.# = 1
  egress.482069346.cidr_blocks.0 = 0.0.0.0/0
  egress.482069346.description = 
  egress.482069346.from_port = 0
  egress.482069346.ipv6_cidr_blocks.# = 0
  egress.482069346.prefix_list_ids.# = 0
  egress.482069346.protocol = -1
  egress.482069346.security_groups.# = 0
  egress.482069346.self = false
  egress.482069346.to_port = 0
  ingress.# = 1
  ingress.2541437006.cidr_blocks.# = 1
  ingress.2541437006.cidr_blocks.0 = 0.0.0.0/0
  ingress.2541437006.description = 
  ingress.2541437006.from_port = 22
  ingress.2541437006.ipv6_cidr_blocks.# = 0
  ingress.2541437006.prefix_list_ids.# = 0
  ingress.2541437006.protocol = tcp
  ingress.2541437006.security_groups.# = 0
  ingress.2541437006.self = false
  ingress.2541437006.to_port = 22
  name = launch-wizard-1
  owner_id = 193178401758
  tags.% = 0
  vpc_id = vpc-0ededcb9275dc19f9
}

# SG for Web Access from NAT
## Private Subnet
resource "aws_security_group" "web_from_nat_prv_sg" {
  id = sg-0e79dd50a5ddfa790
  arn = arn:aws:ec2:us-east-1:193178401758:security-group/sg-0e79dd50a5ddfa790
  description = launch-wizard-1 created 2022-03-29T06:50:44.781+03:00
  egress.# = 1
  egress.482069346.cidr_blocks.# = 1
  egress.482069346.cidr_blocks.0 = 0.0.0.0/0
  egress.482069346.description = 
  egress.482069346.from_port = 0
  egress.482069346.ipv6_cidr_blocks.# = 0
  egress.482069346.prefix_list_ids.# = 0
  egress.482069346.protocol = -1
  egress.482069346.security_groups.# = 0
  egress.482069346.self = false
  egress.482069346.to_port = 0
  ingress.# = 1
  ingress.2541437006.cidr_blocks.# = 1
  ingress.2541437006.cidr_blocks.0 = 0.0.0.0/0
  ingress.2541437006.description = 
  ingress.2541437006.from_port = 22
  ingress.2541437006.ipv6_cidr_blocks.# = 0
  ingress.2541437006.prefix_list_ids.# = 0
  ingress.2541437006.protocol = tcp
  ingress.2541437006.security_groups.# = 0
  ingress.2541437006.self = false
  ingress.2541437006.to_port = 22
  name = launch-wizard-1
  owner_id = 193178401758
  tags.% = 0
  vpc_id = vpc-0ededcb9275dc19f9
}
## Public Subnet
resource "aws_security_group" "web_from_nat_pub_sg" {
  id = sg-0441ae5390392e4c6
  arn = arn:aws:ec2:us-east-1:193178401758:security-group/sg-0441ae5390392e4c6
  description = Allow HTTP and HTTPS
  egress.# = 1
  egress.482069346.cidr_blocks.# = 1
  egress.482069346.cidr_blocks.0 = 0.0.0.0/0
  egress.482069346.description = 
  egress.482069346.from_port = 0
  egress.482069346.ipv6_cidr_blocks.# = 0
  egress.482069346.prefix_list_ids.# = 0
  egress.482069346.protocol = -1
  egress.482069346.security_groups.# = 0
  egress.482069346.self = false
  egress.482069346.to_port = 0
  ingress.# = 2
  ingress.2214680975.cidr_blocks.# = 1
  ingress.2214680975.cidr_blocks.0 = 0.0.0.0/0
  ingress.2214680975.description = 
  ingress.2214680975.from_port = 80
  ingress.2214680975.ipv6_cidr_blocks.# = 0
  ingress.2214680975.prefix_list_ids.# = 0
  ingress.2214680975.protocol = tcp
  ingress.2214680975.security_groups.# = 0
  ingress.2214680975.self = false
  ingress.2214680975.to_port = 80
  ingress.2617001939.cidr_blocks.# = 1
  ingress.2617001939.cidr_blocks.0 = 0.0.0.0/0
  ingress.2617001939.description = 
  ingress.2617001939.from_port = 443
  ingress.2617001939.ipv6_cidr_blocks.# = 0
  ingress.2617001939.prefix_list_ids.# = 0
  ingress.2617001939.protocol = tcp
  ingress.2617001939.security_groups.# = 0
  ingress.2617001939.self = false
  ingress.2617001939.to_port = 443
  name = kpmg-AutoScaling-SecurityGroup
  owner_id = 193178401758
  tags.% = 0
  vpc_id = vpc-0ededcb9275dc19f9
}

###

resource "aws_vpc" "kpmgvpc" {
  id = vpc-0ededcb9275dc19f9
  arn = arn:aws:ec2:us-east-1:193178401758:vpc/vpc-0ededcb9275dc19f9
  assign_generated_ipv6_cidr_block = false
  cidr_block = 10.0.0.0/16
  default_network_acl_id = acl-0891327bb1357651a
  default_route_table_id = rtb-0c95241d9da3d13a8
  default_security_group_id = sg-09e5020641cae02ec
  dhcp_options_id = dopt-0d221a01d5d5f0149
  enable_classiclink = false
  enable_classiclink_dns_support = false
  enable_dns_hostnames = false
  enable_dns_support = true
  instance_tenancy = default
  ipv6_association_id = 
  ipv6_cidr_block = 
  main_route_table_id = rtb-0c95241d9da3d13a8
  owner_id = 193178401758
  tags.% = 1
  tags.Name = kpmg-vpc
}

resource "aws_subnet" "publicsubnet1" {
  id = subnet-0b37abce35e95f9e7
  arn = arn:aws:ec2:us-east-1:193178401758:subnet/subnet-0b37abce35e95f9e7
  assign_ipv6_address_on_creation = false
  availability_zone = us-east-1a
  availability_zone_id = use1-az6
  cidr_block = 10.0.1.0/24
  ipv6_cidr_block = 
  ipv6_cidr_block_association_id = 
  map_public_ip_on_launch = false
  outpost_arn = 
  owner_id = 193178401758
  tags.% = 1
  tags.Name = kpmg-public-subnet-1
  vpc_id = vpc-0ededcb9275dc19f9
}

resource "aws_subnet" "publicsubnet2" {
  id = subnet-02533b3ca601f2214
  arn = arn:aws:ec2:us-east-1:193178401758:subnet/subnet-02533b3ca601f2214
  assign_ipv6_address_on_creation = false
  availability_zone = us-east-1b
  availability_zone_id = use1-az1
  cidr_block = 10.0.2.0/24
  ipv6_cidr_block = 
  ipv6_cidr_block_association_id = 
  map_public_ip_on_launch = false
  outpost_arn = 
  owner_id = 193178401758
  tags.% = 1
  tags.Name = kpmg-public-subnet-2
  vpc_id = vpc-0ededcb9275dc19f9
}

resource "aws_subnet" "privatesubnet3" {
  id = subnet-099f3a7785cd489f4
  arn = arn:aws:ec2:us-east-1:193178401758:subnet/subnet-099f3a7785cd489f4
  assign_ipv6_address_on_creation = false
  availability_zone = us-east-1a
  availability_zone_id = use1-az6
  cidr_block = 10.0.3.0/24
  ipv6_cidr_block = 
  ipv6_cidr_block_association_id = 
  map_public_ip_on_launch = false
  outpost_arn = 
  owner_id = 193178401758
  tags.% = 1
  tags.Name = kpmg-private-subnet-3
  vpc_id = vpc-0ededcb9275dc19f9
}

resource "aws_subnet" "privatesubnet4" {
  id = subnet-0b750e958bdc96bd2
  arn = arn:aws:ec2:us-east-1:193178401758:subnet/subnet-0b750e958bdc96bd2
  assign_ipv6_address_on_creation = false
  availability_zone = us-east-1b
  availability_zone_id = use1-az1
  cidr_block = 10.0.4.0/24
  ipv6_cidr_block = 
  ipv6_cidr_block_association_id = 
  map_public_ip_on_launch = false
  outpost_arn = 
  owner_id = 193178401758
  tags.% = 1
  tags.Name = kpmg-private-subnet-4
  vpc_id = vpc-0ededcb9275dc19f9
}


#### ASG


resource "aws_autoscaling_group" "appasg" {
  id = kpmg-ASG-BE
  arn = arn:aws:autoscaling:us-east-1:193178401758:autoScalingGroup:52d7649d-75ca-4f09-a298-ba9008b249ce:autoScalingGroupName/kpmg-ASG-BE
  availability_zones.# = 2
  availability_zones.1305112097 = us-east-1b
  availability_zones.3569565595 = us-east-1a
  default_cooldown = 300
  desired_capacity = 2
  enabled_metrics.# = 0
  health_check_grace_period = 300
  health_check_type = ELB
  launch_configuration = kpmg-LC-BE
  launch_template.# = 0
  load_balancers.# = 0
  max_instance_lifetime = 0
  max_size = 3
  metrics_granularity = 1Minute
  min_size = 2
  mixed_instances_policy.# = 0
  name = kpmg-ASG-BE
  placement_group = 
  protect_from_scale_in = false
  service_linked_role_arn = arn:aws:iam::193178401758:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling
  suspended_processes.# = 0
  tag.# = 0
  target_group_arns.# = 1
  target_group_arns.870416068 = arn:aws:elasticloadbalancing:us-east-1:193178401758:targetgroup/kpmg-BE-TG/ccb570243171219c
  termination_policies.# = 0
  vpc_zone_identifier.# = 2
  vpc_zone_identifier.1449648110 = subnet-099f3a7785cd489f4
  vpc_zone_identifier.3187746563 = subnet-0b750e958bdc96bd2
}
resource "aws_autoscaling_group" "webasg" {
  id = kpmg-ASG
  arn = arn:aws:autoscaling:us-east-1:193178401758:autoScalingGroup:7e9c17c3-6358-43ca-9910-8ab05bb3b385:autoScalingGroupName/kpmg-ASG
  availability_zones.# = 2
  availability_zones.1305112097 = us-east-1b
  availability_zones.3569565595 = us-east-1a
  default_cooldown = 300
  desired_capacity = 2
  enabled_metrics.# = 0
  health_check_grace_period = 300
  health_check_type = ELB
  launch_configuration = kpmg-LC
  launch_template.# = 0
  load_balancers.# = 0
  max_instance_lifetime = 0
  max_size = 3
  metrics_granularity = 1Minute
  min_size = 2
  mixed_instances_policy.# = 0
  name = kpmg-ASG
  placement_group = 
  protect_from_scale_in = false
  service_linked_role_arn = arn:aws:iam::193178401758:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling
  suspended_processes.# = 0
  tag.# = 0
  target_group_arns.# = 1
  target_group_arns.3167542730 = arn:aws:elasticloadbalancing:us-east-1:193178401758:targetgroup/kpmg-FE-TG/c08da67eba9a829c
  termination_policies.# = 0
  vpc_zone_identifier.# = 2
  vpc_zone_identifier.1449648110 = subnet-099f3a7785cd489f4
  vpc_zone_identifier.3187746563 = subnet-0b750e958bdc96bd2
}



#### Config


resource "aws_launch_configuration" "app-lc" {
  id = kpmg-LC-BE
  arn = arn:aws:autoscaling:us-east-1:193178401758:launchConfiguration:55c12d72-3fa9-40bc-a6e2-ce2bc068528b:launchConfigurationName/kpmg-LC-BE
  associate_public_ip_address = false
  ebs_block_device.# = 0
  ebs_optimized = false
  enable_monitoring = false
  ephemeral_block_device.# = 0
  iam_instance_profile = 
  image_id = ami-00c0bc916a4a1cf66
  instance_type = t2.micro
  key_name = kpmg-keyPair-final-BE
  name = kpmg-LC-BE
  root_block_device.# = 1
  root_block_device.0.delete_on_termination = false
  root_block_device.0.encrypted = false
  root_block_device.0.iops = 0
  root_block_device.0.volume_size = 20
  root_block_device.0.volume_type = gp2
  security_groups.# = 1
  security_groups.3288181379 = sg-0ddc0797e7657bfd7
  spot_price = 
  vpc_classic_link_id = 
  vpc_classic_link_security_groups.# = 0
}
resource "aws_launch_configuration" "web-lc" {
  id = kpmg-LC
  arn = arn:aws:autoscaling:us-east-1:193178401758:launchConfiguration:862ba2f5-834e-4afd-a6a1-9e28d7fc8cd4:launchConfigurationName/kpmg-LC
  associate_public_ip_address = false
  ebs_block_device.# = 0
  ebs_optimized = false
  enable_monitoring = false
  ephemeral_block_device.# = 0
  iam_instance_profile = 
  image_id = ami-00c0bc916a4a1cf66
  instance_type = t2.micro
  key_name = kpmg-keypair-final
  name = kpmg-LC
  root_block_device.# = 1
  root_block_device.0.delete_on_termination = false
  root_block_device.0.encrypted = false
  root_block_device.0.iops = 0
  root_block_device.0.volume_size = 20
  root_block_device.0.volume_type = gp2
  security_groups.# = 1
  security_groups.4259655390 = sg-0441ae5390392e4c6
  spot_price = 
  vpc_classic_link_id = 
  vpc_classic_link_security_groups.# = 0
}


#### EC2

resource "aws_instance" "bastion" {
  id = i-0b5f2d4765a27aa1e
  ami = ami-04505e74c0741db8d
  arn = arn:aws:ec2:us-east-1:193178401758:instance/i-0b5f2d4765a27aa1e
  associate_public_ip_address = true
  availability_zone = us-east-1a
  cpu_core_count = 1
  cpu_threads_per_core = 1
  credit_specification.# = 1
  credit_specification.0.cpu_credits = standard
  disable_api_termination = false
  ebs_block_device.# = 0
  ebs_optimized = false
  ephemeral_block_device.# = 0
  get_password_data = false
  hibernation = false
  iam_instance_profile = 
  instance_state = running
  instance_type = t2.micro
  ipv6_address_count = 0
  ipv6_addresses.# = 0
  key_name = kpmg-keyPair-bastion
  metadata_options.# = 1
  metadata_options.0.http_endpoint = enabled
  metadata_options.0.http_put_response_hop_limit = 1
  metadata_options.0.http_tokens = optional
  monitoring = false
  network_interface.# = 0
  outpost_arn = 
  password_data = 
  placement_group = 
  primary_network_interface_id = eni-03b5ae01731057503
  private_dns = ip-10-0-1-206.ec2.internal
  private_ip = 10.0.1.206
  public_dns = 
  public_ip = 54.81.109.48
  root_block_device.# = 1
  root_block_device.0.delete_on_termination = true
  root_block_device.0.device_name = /dev/sda1
  root_block_device.0.encrypted = false
  root_block_device.0.iops = 100
  root_block_device.0.kms_key_id = 
  root_block_device.0.volume_id = vol-077f9ac91093587b4
  root_block_device.0.volume_size = 8
  root_block_device.0.volume_type = gp2
  security_groups.# = 0
  source_dest_check = true
  subnet_id = subnet-0b37abce35e95f9e7
  tags.% = 0
  tenancy = default
  volume_tags.% = 0
  vpc_security_group_ids.# = 1
  vpc_security_group_ids.3938793199 = sg-0e79dd50a5ddfa790
}

#### ELB

##App-ELB
resource "aws_lb" "netlbapp" {
  id = arn:aws:elasticloadbalancing:us-east-1:193178401758:loadbalancer/app/kpmg-BE-LB/cde3882001557388
  access_logs.# = 1
  access_logs.0.bucket = 
  access_logs.0.enabled = false
  access_logs.0.prefix = 
  arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:loadbalancer/app/kpmg-BE-LB/cde3882001557388
  arn_suffix = app/kpmg-BE-LB/cde3882001557388
  dns_name = internal-kpmg-BE-LB-1183439873.us-east-1.elb.amazonaws.com
  drop_invalid_header_fields = false
  enable_deletion_protection = false
  enable_http2 = true
  idle_timeout = 60
  internal = true
  ip_address_type = ipv4
  load_balancer_type = application
  name = kpmg-BE-LB
  security_groups.# = 1
  security_groups.272363735 = sg-09e5020641cae02ec
  subnet_mapping.# = 2
  subnet_mapping.241886053.allocation_id = 
  subnet_mapping.241886053.subnet_id = subnet-0b750e958bdc96bd2
  subnet_mapping.3493403480.allocation_id = 
  subnet_mapping.3493403480.subnet_id = subnet-099f3a7785cd489f4
  subnets.# = 2
  subnets.1449648110 = subnet-099f3a7785cd489f4
  subnets.3187746563 = subnet-0b750e958bdc96bd2
  tags.% = 0
  vpc_id = vpc-0ededcb9275dc19f9
  zone_id = Z35SXDOTRQ7X7K
}
resource "aws_lb_target_group" "internaltg" {
  id = arn:aws:elasticloadbalancing:us-east-1:193178401758:listener/app/kpmg-BE-LB/cde3882001557388/ce7f577376143c6f
  arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:listener/app/kpmg-BE-LB/cde3882001557388/ce7f577376143c6f
  default_action.# = 1
  default_action.0.authenticate_cognito.# = 0
  default_action.0.authenticate_oidc.# = 0
  default_action.0.fixed_response.# = 0
  default_action.0.forward.# = 0
  default_action.0.order = 0
  default_action.0.redirect.# = 0
  default_action.0.target_group_arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:targetgroup/kpmg-BE-TG/ccb570243171219c
  default_action.0.type = forward
  load_balancer_arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:loadbalancer/app/kpmg-BE-LB/cde3882001557388
  port = 3000
  protocol = HTTP
  ssl_policy = 
}
resource "aws_lb_listener" "internal_listener_app" {
  id = arn:aws:elasticloadbalancing:us-east-1:193178401758:listener/app/kpmg-BE-LB/cde3882001557388/ce7f577376143c6f
  arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:listener/app/kpmg-BE-LB/cde3882001557388/ce7f577376143c6f
  default_action.# = 1
  default_action.0.authenticate_cognito.# = 0
  default_action.0.authenticate_oidc.# = 0
  default_action.0.fixed_response.# = 0
  default_action.0.forward.# = 0
  default_action.0.order = 0
  default_action.0.redirect.# = 0
  default_action.0.target_group_arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:targetgroup/kpmg-BE-TG/ccb570243171219c
  default_action.0.type = forward
  load_balancer_arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:loadbalancer/app/kpmg-BE-LB/cde3882001557388
  port = 3000
  protocol = HTTP
  ssl_policy = 
}

##Web-ELB
resource "aws_lb" "albweb" {
  id = arn:aws:elasticloadbalancing:us-east-1:193178401758:loadbalancer/app/kpmg-FE-LB/637f87339ab5cc48
  access_logs.# = 1
  access_logs.0.bucket = 
  access_logs.0.enabled = false
  access_logs.0.prefix = 
  arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:loadbalancer/app/kpmg-FE-LB/637f87339ab5cc48
  arn_suffix = app/kpmg-FE-LB/637f87339ab5cc48
  dns_name = kpmg-FE-LB-1688110038.us-east-1.elb.amazonaws.com
  drop_invalid_header_fields = false
  enable_deletion_protection = false
  enable_http2 = true
  idle_timeout = 60
  internal = false
  ip_address_type = ipv4
  load_balancer_type = application
  name = kpmg-FE-LB
  security_groups.# = 1
  security_groups.272363735 = sg-09e5020641cae02ec
  subnet_mapping.# = 2
  subnet_mapping.1793643071.allocation_id = 
  subnet_mapping.1793643071.subnet_id = subnet-02533b3ca601f2214
  subnet_mapping.2448172487.allocation_id = 
  subnet_mapping.2448172487.subnet_id = subnet-0b37abce35e95f9e7
  subnets.# = 2
  subnets.1469627674 = subnet-02533b3ca601f2214
  subnets.2267226181 = subnet-0b37abce35e95f9e7
  tags.% = 0
  vpc_id = vpc-0ededcb9275dc19f9
  zone_id = Z35SXDOTRQ7X7K
}
resource "aws_lb_target_group" "tg" {
  id = arn:aws:elasticloadbalancing:us-east-1:193178401758:targetgroup/kpmg-FE-TG/c08da67eba9a829c
  arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:targetgroup/kpmg-FE-TG/c08da67eba9a829c
  arn_suffix = targetgroup/kpmg-FE-TG/c08da67eba9a829c
  deregistration_delay = 300
  health_check.# = 1
  health_check.0.enabled = true
  health_check.0.healthy_threshold = 5
  health_check.0.interval = 30
  health_check.0.matcher = 200
  health_check.0.path = /
  health_check.0.port = traffic-port
  health_check.0.protocol = HTTP
  health_check.0.timeout = 5
  health_check.0.unhealthy_threshold = 2
  load_balancing_algorithm_type = round_robin
  name = kpmg-FE-TG
  port = 80
  protocol = HTTP
  slow_start = 0
  stickiness.# = 1
  stickiness.0.cookie_duration = 86400
  stickiness.0.enabled = false
  stickiness.0.type = lb_cookie
  tags.% = 0
  target_type = instance
  vpc_id = vpc-0ededcb9275dc19f9
}
resource "aws_lb_listener" "external_listener_web" {
  id = arn:aws:elasticloadbalancing:us-east-1:193178401758:loadbalancer/app/kpmg-BE-LB/cde3882001557388
  access_logs.# = 1
  access_logs.0.bucket = 
  access_logs.0.enabled = false
  access_logs.0.prefix = 
  arn = arn:aws:elasticloadbalancing:us-east-1:193178401758:loadbalancer/app/kpmg-BE-LB/cde3882001557388
  arn_suffix = app/kpmg-BE-LB/cde3882001557388
  dns_name = internal-kpmg-BE-LB-1183439873.us-east-1.elb.amazonaws.com
  drop_invalid_header_fields = false
  enable_deletion_protection = false
  enable_http2 = true
  idle_timeout = 60
  internal = true
  ip_address_type = ipv4
  load_balancer_type = application
  name = kpmg-BE-LB
  security_groups.# = 1
  security_groups.272363735 = sg-09e5020641cae02ec
  subnet_mapping.# = 2
  subnet_mapping.241886053.allocation_id = 
  subnet_mapping.241886053.subnet_id = subnet-0b750e958bdc96bd2
  subnet_mapping.3493403480.allocation_id = 
  subnet_mapping.3493403480.subnet_id = subnet-099f3a7785cd489f4
  subnets.# = 2
  subnets.1449648110 = subnet-099f3a7785cd489f4
  subnets.3187746563 = subnet-0b750e958bdc96bd2
  tags.% = 0
  vpc_id = vpc-0ededcb9275dc19f9
  zone_id = Z35SXDOTRQ7X7K
}


