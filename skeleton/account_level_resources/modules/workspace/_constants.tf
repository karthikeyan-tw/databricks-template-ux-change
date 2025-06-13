locals {
  prefix = var.config.enable_auto_prefix ? "${var.environment}-" : ""
  suffix = var.config.enable_auto_suffix ? "-${var.region}" : ""
}

# List of VPC endpoints for Databricks and AWS Private Link
locals {
  # Reference: https://docs.databricks.com/en/resources/supported-regions.html#privatelink
  vpc_endpoints = {
    workspace = tomap({
      ap-northeast-1 = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-02691fd610d24fd64"
      ap-northeast-2 = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0babb9bde64f34d7e"
      ap-south-1     = "com.amazonaws.vpce.ap-south-1.vpce-svc-0dbfe5d9ee18d6411"
      ap-southeast-1 = "com.amazonaws.vpce.ap-southeast-1.vpce-svc-02535b257fc253ff4"
      ap-southeast-2 = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b87155ddd6954974"
      ca-central-1   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0205f197ec0e28d65"
      eu-central-1   = "com.amazonaws.vpce.eu-central-1.vpce-svc-081f78503812597f7"
      eu-west-1      = "com.amazonaws.vpce.eu-west-1.vpce-svc-0da6ebf1461278016"
      eu-west-2      = "com.amazonaws.vpce.eu-west-2.vpce-svc-01148c7cdc1d1326c"
      eu-west-3      = "com.amazonaws.vpce.eu-west-3.vpce-svc-008b9368d1d011f37"
      sa-east-1      = "com.amazonaws.vpce.sa-east-1.vpce-svc-0bafcea8cdfe11b66"
      us-east-1      = "com.amazonaws.vpce.us-east-1.vpce-svc-09143d1e626de2f04"
      us-east-2      = "com.amazonaws.vpce.us-east-2.vpce-svc-041dc2b4d7796b8d3"
      us-west-2      = "com.amazonaws.vpce.eu-west-2.vpce-svc-01148c7cdc1d1326c"
      # us-west-1      = "" # Not supported for this region
    })
    relay = tomap({
      ap-northeast-1 = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-02aa633bda3edbec0"
      ap-northeast-2 = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0dc0e98a5800db5c4"
      ap-south-1     = "com.amazonaws.vpce.ap-south-1.vpce-svc-03fd4d9b61414f3de"
      ap-southeast-1 = "com.amazonaws.vpce.ap-southeast-1.vpce-svc-0557367c6fc1a0c5c"
      ap-southeast-2 = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b4a72e8f825495f6"
      ca-central-1   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0c4e25bdbcbfbb684"
      eu-central-1   = "com.amazonaws.vpce.eu-central-1.vpce-svc-08e5dfca9572c85c4"
      eu-west-1      = "com.amazonaws.vpce.eu-west-1.vpce-svc-09b4eb2bc775f4e8c"
      eu-west-2      = "com.amazonaws.vpce.eu-west-2.vpce-svc-05279412bf5353a45"
      eu-west-3      = "com.amazonaws.vpce.eu-west-3.vpce-svc-005b039dd0b5f857d"
      sa-east-1      = "com.amazonaws.vpce.sa-east-1.vpce-svc-0e61564963be1b43f"
      us-east-1      = "com.amazonaws.vpce.us-east-1.vpce-svc-00018a8c3ff62ffdf"
      us-east-2      = "com.amazonaws.vpce.us-east-2.vpce-svc-090a8fab0d73e39a6"
      us-west-2      = "com.amazonaws.vpce.eu-west-2.vpce-svc-05279412bf5353a45"
      # us-west-1      = "" # Not supported for this region
    })
  }
}

# List of Network ACL rules required by Databricks and validated during workspace provisioning
locals {
  # Reference: https://docs.databricks.com/administration-guide/cloud-configurations/aws/customer-managed-vpc.html#subnet-level-network-acls
  static_rules = yamldecode(file("${path.module}/network_acl_rules.yml"))
  custom_rules = var.config.network_acls
  
  network_acls = {
    public = {
      inbound = [
        for key, rule in concat(local.static_rules.public.inbound, try(local.custom_rules.public.inbound, [])) : {
          rule_number = 10 + key
          rule_action = "allow"
          from_port   = rule.port
          to_port     = try(rule.to_port, rule.port)
          protocol    = rule.protocol
          icmp_type   = try(rule.icmp_type, null)
          cidr_block  = try(rule.cidr_block, "0.0.0.0/0")
        }
      ]

      outbound = [
        for key, rule in concat(local.static_rules.public.outbound, try(local.custom_rules.public.outbound, [])) : {
          rule_number = 10 + key
          rule_action = "allow"
          from_port   = rule.port
          to_port     = try(rule.to_port, rule.port)
          protocol    = rule.protocol
          icmp_type   = try(rule.icmp_type, null)
          cidr_block  = try(rule.cidr_block, "0.0.0.0/0")
        }
      ]
    }

    private = {
      inbound = [
        for key, rule in concat(local.static_rules.private.inbound, try(local.custom_rules.private.inbound, [])) : {
          rule_number = 10 + key
          rule_action = "allow"
          from_port   = rule.port
          to_port     = try(rule.to_port, rule.port)
          protocol    = rule.protocol
          icmp_type   = try(rule.icmp_type, null)
          cidr_block  = try(rule.cidr_block, "0.0.0.0/0")
        }
      ]

      outbound = [
        for key, rule in concat(local.static_rules.private.outbound, try(local.custom_rules.private.outbound, [])) : {
          rule_number = 10 + key
          rule_action = "allow"
          from_port   = rule.port
          to_port     = try(rule.to_port, rule.port)
          protocol    = rule.protocol
          icmp_type   = try(rule.icmp_type, null)
          cidr_block  = try(rule.cidr_block, "0.0.0.0/0")
        }
      ]
    }
  }
}