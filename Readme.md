# Quick Start Guide - IBM Cloud Schematics Large Log Generator

This guide will help you quickly deploy the large log generator on IBM Cloud Schematics.

## Prerequisites

- IBM Cloud account ([Sign up here](https://cloud.ibm.com/registration))
- Access to IBM Cloud Schematics service
- (Optional) IBM Cloud CLI with Schematics plugin

## Quick Deploy Steps

### Option 1: Using IBM Cloud Console (Easiest)

1. **Login to IBM Cloud**
   - Go to https://cloud.ibm.com
   - Login with your credentials

2. **Navigate to Schematics**
   - Search for "Schematics" in the top search bar
   - Click on "Schematics Workspaces"

3. **Create Workspace**
   - Click "Create workspace" button
   - Fill in the details:
     - **Workspace name**: `large-log-generator-test`
     - **Resource group**: Select your resource group (or use "Default")
     - **Location**: Choose a region (e.g., `us-south`, `eu-de`, `jp-tok`)

4. **Configure Repository**
   - **Repository URL**: Enter your Git repository URL containing these files
   - **Personal access token**: (Optional) If using private repo
   - **Terraform version**: Select `terraform_v1.5` or later
   - Click "Next"

5. **Review and Create**
   - Review the workspace settings
   - Click "Create"

6. **Generate Plan**
   - Once workspace is created, click "Generate plan"
   - Wait for plan to complete (1-2 minutes)
   - Review the plan output

7. **Apply Configuration**
   - Click "Apply plan"
   - Confirm the action
   - **Monitor the logs** - This is where you'll see the 100MB+ output!

8. **View Logs**
   - Click on the "Jobs" tab
   - Select the "Apply" job
   - Scroll through the logs to see the extensive output
   - Use the download button to save logs locally

### Option 2: Using IBM Cloud CLI

```bash
# 1. Install IBM Cloud CLI (if not already installed)
# macOS
curl -fsSL https://clis.cloud.ibm.com/install/osx | sh

# Linux
curl -fsSL https://clis.cloud.ibm.com/install/linux | sh

# Windows (PowerShell)
iex(New-Object Net.WebClient).DownloadString('https://clis.cloud.ibm.com/install/powershell')

# 2. Install Schematics plugin
ibmcloud plugin install schematics

# 3. Login to IBM Cloud
ibmcloud login --sso
# Or with API key:
# ibmcloud login --apikey YOUR_API_KEY

# 4. Target your resource group
ibmcloud target -g Default

# 5. Create workspace (replace with your repo URL)
ibmcloud schematics workspace new \
  --name large-log-generator \
  --type terraform_v1.5 \
  --location us-south \
  --resource-group Default \
  --template-repo https://github.com/YOUR_USERNAME/YOUR_REPO \
  --template-folder .

# 6. Note the workspace ID from the output
# Example: us-south.workspace.large-log-generator.a1b2c3d4

# 7. Set workspace ID as variable
export WORKSPACE_ID="your-workspace-id-here"

# 8. Generate plan
ibmcloud schematics plan --id $WORKSPACE_ID

# 9. Apply the configuration
ibmcloud schematics apply --id $WORKSPACE_ID

# 10. View logs
ibmcloud schematics logs --id $WORKSPACE_ID

# 11. Download logs to file
ibmcloud schematics logs --id $WORKSPACE_ID > schematics-logs.txt
```

### Option 3: Local Testing (Before Deploying to Schematics)

```bash
# 1. Clone or download the repository
git clone YOUR_REPO_URL
cd YOUR_REPO_NAME

# 2. Initialize Terraform
terraform init

# 3. (Optional) Customize variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your preferred settings

# 4. Generate plan
terraform plan

# 5. Apply configuration
terraform apply -auto-approve

# 6. View outputs
terraform output

# 7. Check log file size (if redirected to file)
# terraform apply > terraform-output.log 2>&1
# ls -lh terraform-output.log
```

## Customizing Log Size

To generate larger or smaller logs, modify the variables:

### For ~50MB logs (Faster):
```hcl
log_iterations          = 20000
log_message_size        = 1500
resource_count_tier1    = 100
resource_count_tier2    = 100
resource_count_tier3    = 100
resource_count_tier4    = 50
iterations_per_resource = 100
```

### For ~100MB logs (Default):
```hcl
log_iterations          = 50000
log_message_size        = 2000
resource_count_tier1    = 150
resource_count_tier2    = 150
resource_count_tier3    = 150
resource_count_tier4    = 100
iterations_per_resource = 150
```

### For ~200MB+ logs (Slower):
```hcl
log_iterations          = 100000
log_message_size        = 3000
resource_count_tier1    = 200
resource_count_tier2    = 200
resource_count_tier3    = 200
resource_count_tier4    = 150
iterations_per_resource = 200
```

## Setting Variables in Schematics

1. Go to your workspace
2. Click on "Settings" tab
3. Scroll to "Variables" section
4. Click "Add variable"
5. Add each variable:
   - **Name**: `log_iterations`
   - **Type**: `number`
   - **Value**: `50000`
   - Click "Save"
6. Repeat for other variables

## Monitoring Execution

- **Execution Time**: Expect 5-15 minutes depending on configuration
- **Log Size**: Monitor in real-time in the Schematics console
- **Progress**: Watch the resource creation progress in the logs

## Downloading Logs

### From Console:
1. Navigate to workspace → Jobs → Select job
2. Click the download icon in the logs section
3. Save the log file locally

### Using CLI:
```bash
ibmcloud schematics logs --id $WORKSPACE_ID > large-logs.txt
```

## Cleanup

```bash
# Using CLI
ibmcloud schematics destroy --id $WORKSPACE_ID

# Or in console
# Workspace → Actions → Destroy resources
```

## Troubleshooting

### Issue: Execution timeout
**Solution**: Reduce the number of iterations or resources

### Issue: Logs not reaching expected size
**Solution**: Increase variable values in terraform.tfvars

### Issue: Out of memory
**Solution**: Add more `depends_on` relationships to serialize execution

### Issue: Workspace creation fails
**Solution**: Check repository URL and access permissions

## Support

For issues or questions:
- Check the main README.md for detailed documentation
- Review IBM Cloud Schematics documentation
- Check Terraform logs for specific errors

## Next Steps

After successful deployment:
1. Analyze the log output
2. Test log retrieval mechanisms
3. Experiment with different variable configurations
4. Integrate with your monitoring/logging systems
