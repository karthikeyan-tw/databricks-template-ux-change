# AWS VPC | Terraform module

This module is a fork of the official [AWS VPC Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest).

The reason behind the fork is that we cannot implement [IP Address Manager (IPAM)](https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html) correctly due to the fact that VPC and subnets are created at the same time during the Terraform module execution.

In the official Terraform module, we found a segment of the documentation called [VPC CIDR from AWS IP Address Manager (IPAM)](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest#vpc-cidr-from-aws-ip-address-manager-ipam) that suggests using the IPAM CIDR preview by applying the Terraform resources `aws_vpc_ipam_preview_next_cidr`.

In reality, this technique provides a workaround for the first Terraform apply but subsequent executions are often impacted by an "unwanted" recalculation of CIDRs and subnets.

# Terraform documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.53.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.53.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.flow_log](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/eip) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/flow_log) | resource |
| [aws_iam_policy.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/nat_gateway) | resource |
| [aws_network_acl.private](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/network_acl) | resource |
| [aws_network_acl.public](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.private_inbound](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.private_outbound](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.public_inbound](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.public_outbound](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/network_acl_rule) | resource |
| [aws_route.private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.flow_log_cloudwatch_assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones names or ids in the region | `list(string)` | `[]` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | (Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id` | `string` | `"10.0.0.0/16"` | no |
| <a name="input_create_flow_log_cloudwatch_iam_role"></a> [create\_flow\_log\_cloudwatch\_iam\_role](#input\_create\_flow\_log\_cloudwatch\_iam\_role) | Whether to create IAM role for VPC Flow Logs | `bool` | `false` | no |
| <a name="input_create_flow_log_cloudwatch_log_group"></a> [create\_flow\_log\_cloudwatch\_log\_group](#input\_create\_flow\_log\_cloudwatch\_log\_group) | Whether to create CloudWatch log group for VPC Flow Logs | `bool` | `false` | no |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Controls if an Internet Gateway is created for public subnets and the related routes that connect them | `bool` | `true` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Should be true to enable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Whether or not to enable VPC Flow Logs | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `false` | no |
| <a name="input_external_nat_ip_ids"></a> [external\_nat\_ip\_ids](#input\_external\_nat\_ip\_ids) | List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse\_nat\_ips) | `list(string)` | `[]` | no |
| <a name="input_external_nat_ips"></a> [external\_nat\_ips](#input\_external\_nat\_ips) | List of EIPs to be used for `nat_public_ips` output (used in combination with reuse\_nat\_ips and external\_nat\_ip\_ids) | `list(string)` | `[]` | no |
| <a name="input_flow_log_cloudwatch_iam_role_arn"></a> [flow\_log\_cloudwatch\_iam\_role\_arn](#input\_flow\_log\_cloudwatch\_iam\_role\_arn) | The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow\_log\_destination\_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided | `string` | `""` | no |
| <a name="input_flow_log_cloudwatch_log_group_class"></a> [flow\_log\_cloudwatch\_log\_group\_class](#input\_flow\_log\_cloudwatch\_log\_group\_class) | Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT\_ACCESS | `string` | `null` | no |
| <a name="input_flow_log_cloudwatch_log_group_kms_key_id"></a> [flow\_log\_cloudwatch\_log\_group\_kms\_key\_id](#input\_flow\_log\_cloudwatch\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data for VPC flow logs | `string` | `null` | no |
| <a name="input_flow_log_cloudwatch_log_group_name_prefix"></a> [flow\_log\_cloudwatch\_log\_group\_name\_prefix](#input\_flow\_log\_cloudwatch\_log\_group\_name\_prefix) | Specifies the name prefix of CloudWatch Log Group for VPC flow logs | `string` | `"/aws/vpc-flow-log/"` | no |
| <a name="input_flow_log_cloudwatch_log_group_name_suffix"></a> [flow\_log\_cloudwatch\_log\_group\_name\_suffix](#input\_flow\_log\_cloudwatch\_log\_group\_name\_suffix) | Specifies the name suffix of CloudWatch Log Group for VPC flow logs | `string` | `""` | no |
| <a name="input_flow_log_cloudwatch_log_group_retention_in_days"></a> [flow\_log\_cloudwatch\_log\_group\_retention\_in\_days](#input\_flow\_log\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group for VPC flow logs | `number` | `null` | no |
| <a name="input_flow_log_cloudwatch_log_group_skip_destroy"></a> [flow\_log\_cloudwatch\_log\_group\_skip\_destroy](#input\_flow\_log\_cloudwatch\_log\_group\_skip\_destroy) | Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state | `bool` | `false` | no |
| <a name="input_flow_log_deliver_cross_account_role"></a> [flow\_log\_deliver\_cross\_account\_role](#input\_flow\_log\_deliver\_cross\_account\_role) | (Optional) ARN of the IAM role that allows Amazon EC2 to publish flow logs across accounts. | `string` | `null` | no |
| <a name="input_flow_log_destination_arn"></a> [flow\_log\_destination\_arn](#input\_flow\_log\_destination\_arn) | The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create\_flow\_log\_cloudwatch\_log\_group is set to false this argument must be provided | `string` | `""` | no |
| <a name="input_flow_log_destination_type"></a> [flow\_log\_destination\_type](#input\_flow\_log\_destination\_type) | Type of flow log destination. Can be s3, kinesis-data-firehose or cloud-watch-logs | `string` | `"cloud-watch-logs"` | no |
| <a name="input_flow_log_file_format"></a> [flow\_log\_file\_format](#input\_flow\_log\_file\_format) | (Optional) The format for the flow log. Valid values: `plain-text`, `parquet` | `string` | `null` | no |
| <a name="input_flow_log_hive_compatible_partitions"></a> [flow\_log\_hive\_compatible\_partitions](#input\_flow\_log\_hive\_compatible\_partitions) | (Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3 | `bool` | `false` | no |
| <a name="input_flow_log_log_format"></a> [flow\_log\_log\_format](#input\_flow\_log\_log\_format) | The fields to include in the flow log record, in the order in which they should appear | `string` | `null` | no |
| <a name="input_flow_log_max_aggregation_interval"></a> [flow\_log\_max\_aggregation\_interval](#input\_flow\_log\_max\_aggregation\_interval) | The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds | `number` | `600` | no |
| <a name="input_flow_log_per_hour_partition"></a> [flow\_log\_per\_hour\_partition](#input\_flow\_log\_per\_hour\_partition) | (Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries | `bool` | `false` | no |
| <a name="input_flow_log_traffic_type"></a> [flow\_log\_traffic\_type](#input\_flow\_log\_traffic\_type) | The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL | `string` | `"ALL"` | no |
| <a name="input_ipv4_ipam_pool_id"></a> [ipv4\_ipam\_pool\_id](#input\_ipv4\_ipam\_pool\_id) | (Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR | `string` | `null` | no |
| <a name="input_ipv4_netmask_length"></a> [ipv4\_netmask\_length](#input\_ipv4\_netmask\_length) | (Optional) The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4\_ipam\_pool\_id | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_nat_gateway_destination_cidr_block"></a> [nat\_gateway\_destination\_cidr\_block](#input\_nat\_gateway\_destination\_cidr\_block) | Used to pass a custom destination route for private NAT Gateway. If not specified, the default 0.0.0.0/0 is used as a destination route | `string` | `"0.0.0.0/0"` | no |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs` | `bool` | `false` | no |
| <a name="input_private_dedicated_network_acl"></a> [private\_dedicated\_network\_acl](#input\_private\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for private subnets | `bool` | `false` | no |
| <a name="input_private_inbound_acl_rules"></a> [private\_inbound\_acl\_rules](#input\_private\_inbound\_acl\_rules) | Private subnets inbound network ACLs | `list(map(string))` | <pre>[<br/>  {<br/>    "cidr_block": "0.0.0.0/0",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "rule_action": "allow",<br/>    "rule_number": 100,<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_private_outbound_acl_rules"></a> [private\_outbound\_acl\_rules](#input\_private\_outbound\_acl\_rules) | Private subnets outbound network ACLs | `list(map(string))` | <pre>[<br/>  {<br/>    "cidr_block": "0.0.0.0/0",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "rule_action": "allow",<br/>    "rule_number": 100,<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_private_subnet_names"></a> [private\_subnet\_names](#input\_private\_subnet\_names) | Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_private_subnet_suffix"></a> [private\_subnet\_suffix](#input\_private\_subnet\_suffix) | Suffix to append to private subnets name | `string` | `"private"` | no |
| <a name="input_public_dedicated_network_acl"></a> [public\_dedicated\_network\_acl](#input\_public\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for public subnets | `bool` | `false` | no |
| <a name="input_public_inbound_acl_rules"></a> [public\_inbound\_acl\_rules](#input\_public\_inbound\_acl\_rules) | Public subnets inbound network ACLs | `list(map(string))` | <pre>[<br/>  {<br/>    "cidr_block": "0.0.0.0/0",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "rule_action": "allow",<br/>    "rule_number": 100,<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_public_outbound_acl_rules"></a> [public\_outbound\_acl\_rules](#input\_public\_outbound\_acl\_rules) | Public subnets outbound network ACLs | `list(map(string))` | <pre>[<br/>  {<br/>    "cidr_block": "0.0.0.0/0",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "rule_action": "allow",<br/>    "rule_number": 100,<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_public_subnet_names"></a> [public\_subnet\_names](#input\_public\_subnet\_names) | Explicit values to use in the Name tag on public subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_public_subnet_suffix"></a> [public\_subnet\_suffix](#input\_public\_subnet\_suffix) | Suffix to append to public subnets name | `string` | `"public"` | no |
| <a name="input_reuse_nat_ips"></a> [reuse\_nat\_ips](#input\_reuse\_nat\_ips) | Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external\_nat\_ip\_ids' variable | `bool` | `false` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `false` | no |
| <a name="input_subnet_newbits"></a> [subnet\_newbits](#input\_subnet\_newbits) | New bits to calculate the public and private subnets CIDR blocks from VPC CIDR | `number` | `4` | no |
| <a name="input_subnet_partition_newbits"></a> [subnet\_partition\_newbits](#input\_subnet\_partition\_newbits) | New bits to calculate partitions for public and private subnets | `number` | `2` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_flow_log_iam_policy_name"></a> [vpc\_flow\_log\_iam\_policy\_name](#input\_vpc\_flow\_log\_iam\_policy\_name) | Name of the IAM policy | `string` | `"vpc-flow-log-to-cloudwatch"` | no |
| <a name="input_vpc_flow_log_iam_policy_use_name_prefix"></a> [vpc\_flow\_log\_iam\_policy\_use\_name\_prefix](#input\_vpc\_flow\_log\_iam\_policy\_use\_name\_prefix) | Determines whether the name of the IAM policy (`vpc_flow_log_iam_policy_name`) is used as a prefix | `bool` | `true` | no |
| <a name="input_vpc_flow_log_iam_role_name"></a> [vpc\_flow\_log\_iam\_role\_name](#input\_vpc\_flow\_log\_iam\_role\_name) | Name to use on the VPC Flow Log IAM role created | `string` | `"vpc-flow-log-role"` | no |
| <a name="input_vpc_flow_log_iam_role_use_name_prefix"></a> [vpc\_flow\_log\_iam\_role\_use\_name\_prefix](#input\_vpc\_flow\_log\_iam\_role\_use\_name\_prefix) | Determines whether the IAM role name (`vpc_flow_log_iam_role_name_name`) is used as a prefix | `bool` | `true` | no |
| <a name="input_vpc_flow_log_permissions_boundary"></a> [vpc\_flow\_log\_permissions\_boundary](#input\_vpc\_flow\_log\_permissions\_boundary) | The ARN of the Permissions Boundary for the VPC Flow Log IAM Role | `string` | `null` | no |
| <a name="input_vpc_flow_log_tags"></a> [vpc\_flow\_log\_tags](#input\_vpc\_flow\_log\_tags) | Additional tags for the VPC Flow Logs | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | A list of availability zones specified as argument to this module |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id) | The ID of the default network ACL |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the default route table |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_igw_arn"></a> [igw\_arn](#output\_igw\_arn) | The ARN of the Internet Gateway |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | The ID of the Internet Gateway |
| <a name="output_name"></a> [name](#output\_name) | The name of the VPC specified as argument to this module |
| <a name="output_nat_ids"></a> [nat\_ids](#output\_nat\_ids) | List of allocation ID of Elastic IPs created for AWS NAT Gateway |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | List of public Elastic IPs created for AWS NAT Gateway |
| <a name="output_natgw_ids"></a> [natgw\_ids](#output\_natgw\_ids) | List of NAT Gateway IDs |
| <a name="output_natgw_interface_ids"></a> [natgw\_interface\_ids](#output\_natgw\_interface\_ids) | List of Network Interface IDs assigned to NAT Gateways |
| <a name="output_private_nat_gateway_route_ids"></a> [private\_nat\_gateway\_route\_ids](#output\_private\_nat\_gateway\_route\_ids) | List of IDs of the private nat gateway route |
| <a name="output_private_network_acl_arn"></a> [private\_network\_acl\_arn](#output\_private\_network\_acl\_arn) | ARN of the private network ACL |
| <a name="output_private_network_acl_id"></a> [private\_network\_acl\_id](#output\_private\_network\_acl\_id) | ID of the private network ACL |
| <a name="output_private_route_table_association_ids"></a> [private\_route\_table\_association\_ids](#output\_private\_route\_table\_association\_ids) | List of IDs of the private route table association |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of IDs of private route tables |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | List of ARNs of private subnets |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_public_internet_gateway_route_id"></a> [public\_internet\_gateway\_route\_id](#output\_public\_internet\_gateway\_route\_id) | ID of the internet gateway route |
| <a name="output_public_network_acl_arn"></a> [public\_network\_acl\_arn](#output\_public\_network\_acl\_arn) | ARN of the public network ACL |
| <a name="output_public_network_acl_id"></a> [public\_network\_acl\_id](#output\_public\_network\_acl\_id) | ID of the public network ACL |
| <a name="output_public_route_table_association_ids"></a> [public\_route\_table\_association\_ids](#output\_public\_route\_table\_association\_ids) | List of IDs of the public route table association |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of IDs of public route tables |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | List of ARNs of public subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#output\_vpc\_enable\_dns\_hostnames) | Whether or not the VPC has DNS hostname support |
| <a name="output_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#output\_vpc\_enable\_dns\_support) | Whether or not the VPC has DNS support |
| <a name="output_vpc_flow_log_cloudwatch_iam_role_arn"></a> [vpc\_flow\_log\_cloudwatch\_iam\_role\_arn](#output\_vpc\_flow\_log\_cloudwatch\_iam\_role\_arn) | The ARN of the IAM role used when pushing logs to Cloudwatch log group |
| <a name="output_vpc_flow_log_deliver_cross_account_role"></a> [vpc\_flow\_log\_deliver\_cross\_account\_role](#output\_vpc\_flow\_log\_deliver\_cross\_account\_role) | The ARN of the IAM role used when pushing logs cross account |
| <a name="output_vpc_flow_log_destination_arn"></a> [vpc\_flow\_log\_destination\_arn](#output\_vpc\_flow\_log\_destination\_arn) | The ARN of the destination for VPC Flow Logs |
| <a name="output_vpc_flow_log_destination_type"></a> [vpc\_flow\_log\_destination\_type](#output\_vpc\_flow\_log\_destination\_type) | The type of the destination for VPC Flow Logs |
| <a name="output_vpc_flow_log_id"></a> [vpc\_flow\_log\_id](#output\_vpc\_flow\_log\_id) | The ID of the Flow Log resource |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_main_route_table_id"></a> [vpc\_main\_route\_table\_id](#output\_vpc\_main\_route\_table\_id) | The ID of the main route table associated with this VPC |
| <a name="output_vpc_owner_id"></a> [vpc\_owner\_id](#output\_vpc\_owner\_id) | The ID of the AWS account that owns the VPC |
<!-- END_TF_DOCS -->