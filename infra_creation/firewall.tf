# resource "aws_networkfirewall_rule_group" "SIG_rule_group_1" {
#   capacity = 50
#   name     = "SIG-firewall-rule-group-domain-deny"
#   type     = "STATEFUL"
#   rule_group {
#     rules_source {
#       rules_source_list {
#         generated_rules_type = "DENYLIST"
#         target_types         = ["HTTP_HOST"]
#         targets              = [".google.com"]
#       }
#     }
#     stateful_rule_options {
#       rule_order = "STRICT_ORDER"
#     }
#   }
# }
# resource "aws_networkfirewall_rule_group" "SIG_rule_group_2" {
#   capacity = 10
#   name     = "deny-ssh"
#   type     = "STATEFUL"
#   rule_group {
#     rules_source {
#       stateful_rule {
#         action = "PASS"
#         header {
#           destination      = "ANY"
#           destination_port = 22
#           direction        = "ANY"
#           protocol         = "SSH"
#           source           = "ANY"
#           source_port      = "ANY"
#         }
#         rule_option {
#           keyword  = "sid"
#           settings = ["1"]
#         }
#       }
#     }
#     stateful_rule_options {
#       rule_order = "STRICT_ORDER"
#     }
#   }
# }

# resource "aws_subnet" "SIG_firewall_subnet" {
#   vpc_id                  = aws_vpc.SIG_spoke.id
#   cidr_block              =  "192.168.136.64/26"  # Adjust the CIDR block appropriately
#   availability_zone       = "ap-south-1a"
#   tags = {
#     Name = "SIG_firewall_subnet"
#   }
# }



# resource "aws_networkfirewall_firewall_policy" "SIG_firewall_policy" {
#   name = "SIG-firewall-policy"

#   firewall_policy {
#     stateless_default_actions          = ["aws:forward_to_sfe"]
#     stateless_fragment_default_actions = ["aws:forward_to_sfe"]
#     stateful_rule_group_reference {
#       priority = 10
#       resource_arn = aws_networkfirewall_rule_group.SIG_rule_group_2.arn
#     }
#     stateful_rule_group_reference {
#       priority = 1
#       resource_arn = aws_networkfirewall_rule_group.SIG_rule_group_1.arn
#     }
#     stateful_engine_options {
#       rule_order = "STRICT_ORDER"
#     }
   
#   }

# }
 
# resource "aws_networkfirewall_firewall" "SIG_firewall" {
#   name                = "SIG-firewall"
#   firewall_policy_arn = aws_networkfirewall_firewall_policy.SIG_firewall_policy.arn
#   vpc_id              = aws_vpc.SIG_spoke.id
#   subnet_mapping {
#     subnet_id = aws_subnet.SIG_firewall_subnet.id
#   }
# }

