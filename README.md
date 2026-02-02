# Terraform Learning (AWS)

This project provisions AWS infrastructure for learning purposes, including:
- VPC, public/private subnets, route tables, IGW, NAT Gateway
- EC2 instances (direct + module-based)
- Security groups for SSH/HTTP/HTTPS/ICMP
- S3 bucket with ownership controls
- Autoscaling groups via the public registry module

Important: This creates billable AWS resources. Destroy them when done.

## Prerequisites
- Terraform CLI installed
- AWS credentials configured (env vars or `aws configure`)
- Permissions for VPC, EC2, EIP/NAT, S3, IAM, Autoscaling
- PowerShell available if running locally on Windows (used by `local-exec`)

## Local backend (default)
Terraform uses the local backend when no backend is configured.

1. (Optional) set variables in a local file:
   - Create `terraform.tfvars` (not committed) with your overrides.
2. Initialize:
   - `terraform init`
3. Plan:
   - `terraform plan -out tfplan`
4. Apply:
   - `terraform apply tfplan`
5. Outputs:
   - `terraform output`
6. Cleanup:
   - `terraform destroy`

State is stored locally in `terraform.tfstate`.

## Remote backend (Terraform Cloud)
Use Terraform Cloud to store state remotely. For this config, a CLI-driven
workspace (local execution) is recommended because the configuration uses
`local_file` and `local-exec` (PowerShell) which expect local execution.

1. Create a Terraform Cloud organization and a CLI-driven workspace.
2. In the workspace, set AWS credentials (e.g., `AWS_ACCESS_KEY_ID`,
   `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION` if desired).
3. Login from your machine:
   - `terraform login`
4. Enable the remote backend by adding a file named `backend.remote.tf`
   (or uncomment the backend block in `terraform.tf`) and set your org/workspace:

   ```hcl
   terraform {
     backend "remote" {
       hostname     = "app.terraform.io"
       organization = "YOUR_ORG"

       workspaces {
         name = "my-aws-app"
       }
     }
   }
   ```

5. Reinitialize and migrate state:
   - `terraform init -reconfigure`
6. Plan/apply as usual:
   - `terraform plan`
   - `terraform apply`

## Switch back to local backend
1. Remove or comment out the remote backend block.
2. Run:
   - `terraform init -reconfigure`

## Variables
Defaults live in `variables.tf`. Key inputs:
- `vpc_cidr`, `vpc_name`
- `public_subnets`, `private_subnets`
- `variables_sub_*` (subnet settings used in the example)
- `environment`

The AWS region is currently set in `terraform.tf` (`us-east-1`). Update the
provider block if you want a different region.

## Notes
- `MyTerraformInstanceKey.pem` is generated locally; keep it safe and uncommitted.
- Security groups allow 22/80/443 and ICMP from `0.0.0.0/0`; tighten for real use.
- If you enable remote execution in Terraform Cloud, `local-exec` and local files
  may not behave as expected.
