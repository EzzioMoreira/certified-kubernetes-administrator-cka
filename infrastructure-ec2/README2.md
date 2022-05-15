## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_web_provisioner"></a> [web\_provisioner](#module\_web\_provisioner) | github.com/cloudposse/tf_ansible | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/instance) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/key_pair) | resource |
| [aws_security_group.allow_access](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_k8s](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Instance name used in tags | `list(any)` | <pre>[<br>  "srv-01",<br>  "srv-02",<br>  "srv-03"<br>]</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of instance aws ec2 | `string` | `"t3a.medium"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID the virtual private cloud VPC | `string` | `"vpc-02c75729dffa2b08b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
