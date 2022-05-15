# Provisioning infrastructure 

Use this project Terraform for provisioning your infrastructure.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/instance) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/key_pair) | resource |
| [aws_security_group.allow_acesso](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Instance name used in tags | `list` | <pre>[<br>  "srv-01",<br>  "srv-02",<br>  "srv-03"<br>]</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of instance aws ec2 | `string` | `"t3a.medium"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |

## For help, run the following commands:

```make
make help: ## Run make help 
terraform-init: ## Run terraform init to download all necessary plugins
terraform-plan: ## Exec a terraform plan and puts it on a file called plano
terraform-apply: ## Uses plano to apply the changes on AWS.
terraform-destroy: ## Destroy all resources created by the terraform file in this repo.
```
