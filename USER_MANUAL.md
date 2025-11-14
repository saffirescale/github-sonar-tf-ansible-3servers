# User Manual — Setup & Execution

## Prerequisites
- An AWS account with an IAM user having EC2, VPC, Subnet, Security Group, and IAM privileges for resources created by Terraform.
- Local tools installed:
  - Terraform v1.0+
  - Ansible 2.9+
  - AWS CLI (configured `aws configure`)
  - Git
  - Node.js (for building sample app)
  - ssh keypair available for Linux instances
- GitHub repository where you will push code and enable GitHub Actions.
- SonarQube server (self-hosted) or SonarCloud. If SonarCloud, use SonarCloud tokens and organization config.

## Repo layout (local)
```
devops_demo_bundle/
├─ terraform/
├─ ansible/
├─ github/
├─ app/
├─ scripts/
├─ USER_MANUAL.md
└─ README.md
```

## 1) GitHub Setup
1. Create a repository on GitHub and push this code to it.
2. On GitHub, add repository secrets (Settings → Secrets → Actions):
   - `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION` (e.g. ap-south-1)
   - `SSH_PRIVATE_KEY` (base64 or raw -- used by Actions to connect for testing)
   - `GITHUB_TOKEN` (auto-provided in Actions)
   - `SONAR_HOST_URL`
   - `SONAR_TOKEN`
   - `GH_PACKAGE_REGISTRY_TOKEN` (if needed for publishing packages)

> For GitHub Packages (npm), enable the repo and configure `package.json` accordingly.

## 2) Terraform
1. Edit `terraform/variables.tf` to set your key pair name and VPC/subnet IDs if required.
2. Initialize Terraform:
```bash
cd terraform
terraform init
terraform plan -out=tfplan
```
3. Apply:
```bash
terraform apply "tfplan"
```
Terraform will provision 3 instances (Ubuntu, CentOS, Windows) and output the public IPs.

**Note:** Replace the AMIs with the correct region-specific AMIs.

## 3) Ansible
1. After Terraform finishes, update `ansible/inventory.ini` with the instance IPs and the SSH user as printed by Terraform outputs.
2. Install dependencies:
```bash
pip3 install ansible boto3 paramiko
```
3. Run playbook:
```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --private-key /path/to/your/key.pem
```
This will:
- Install Node.js, Apache, MySQL (as per role tasks)
- Fetch artifact from GitHub Packages using credentials (you'll configure auth in the playbook or via `.npmrc` for Node artifacts)

## 4) GitHub Actions (CI/CD)
- The workflow `github/workflows/ci-cd.yml` demonstrates:
  - Checkout
  - Setup Node
  - Run tests
  - SonarQube scanner
  - Publish package to GitHub Packages (npm)
  - Optionally trigger Terraform (if you enable `apply` step; requires secrets)
- The workflow uses repository secrets for tokens.

## 5) CPU Dump Scripts
- `scripts/collect_cpu_dump.sh` — runnable on Linux instances to capture top, ps, and gcore style dump (requires gcore/apt-get).
- `scripts/collect_cpu_dump.ps1` — PowerShell for Windows to capture process list and performance counters.

## Security & Hardening
- Do not store secrets in plaintext.
- Use GitHub Secrets and AWS IAM roles where possible.
- For production, use CI runners in private subnets; use SSM to avoid exposing SSH.

## Cleaning up
- Destroy infra:
```bash
cd terraform
terraform destroy
```

## Troubleshooting
- If Ansible cannot connect to instances, verify security group inbound rules (SSH/RDP) and keypair.
- Ensure proper AMIs/region compatibility.
- Sonar scan failures will fail CI; adjust rules in SonarQube Quality Gate.

