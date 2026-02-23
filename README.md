# IBM Cloud Schematics Large Log Generator

This Terraform template is designed to run on IBM Cloud Schematics and generate extensive log output (100MB+) for testing log handling, storage, and retrieval capabilities.

## Overview

The template creates multiple `null_resource` instances that execute shell commands to generate large amounts of log data. The log generation is achieved through:

- **350 null_resource instances** across 4 different log generators
- **Multiple iterations** per instance (100-200 iterations each)
- **Verbose output** including timestamps, random data, and structured messages
- **Terraform outputs** that contribute additional log entries

## Estimated Log Size

With default configuration:
- **Log Generator 1**: 100 instances × 100 iterations × ~500 bytes = ~5 MB
- **Log Generator 2**: 100 instances × 100 iterations × ~800 bytes = ~8 MB
- **Log Generator 3**: 100 instances × 100 iterations × ~600 bytes = ~6 MB
- **Log Generator 4**: 50 instances × 200 iterations × ~700 bytes = ~7 MB
- **Terraform outputs**: Additional ~5-10 MB
- **Total estimated**: **30-50 MB minimum**, can reach 100MB+ depending on execution environment

## Usage with IBM Cloud Schematics

### Method 1: Using IBM Cloud Console

1. Log in to [IBM Cloud Console](https://cloud.ibm.com)
2. Navigate to **Schematics** service
3. Click **Create workspace**
4. Configure workspace:
   - **Name**: `large-log-generator`
   - **Resource group**: Select your resource group
   - **Location**: Select a region
5. Under **Repository**:
   - **Repository URL**: Provide your Git repository URL containing this template
   - Or upload the files directly
6. Click **Create**
7. Once workspace is created, click **Generate plan**
8. Review the plan, then click **Apply plan**
9. Monitor the logs in the Schematics workspace

### Method 2: Using IBM Cloud CLI

```bash
# Install IBM Cloud CLI and Schematics plugin
ibmcloud plugin install schematics

# Login to IBM Cloud
ibmcloud login --sso

# Create workspace
ibmcloud schematics workspace new \
  --name large-log-generator \
  --type terraform_v1.5 \
  --location us-south \
  --resource-group Default \
  --github-token <YOUR_GITHUB_TOKEN> \
  --template-repo https://github.com/your-repo/terraform-large-logs \
  --template-folder .

# Get workspace ID from output
WORKSPACE_ID=<workspace-id>

# Generate plan
ibmcloud schematics plan --id $WORKSPACE_ID

# Apply the plan
ibmcloud schematics apply --id $WORKSPACE_ID

# View logs
ibmcloud schematics logs --id $WORKSPACE_ID
```

### Method 3: Using Terraform CLI (Local Testing)

```bash
# Initialize Terraform
terraform init

# Generate plan
terraform plan

# Apply configuration
terraform apply -auto-approve

# View outputs
terraform output
```

## Configuration Variables

You can customize the log generation by modifying variables:

```hcl
variable "log_iterations" {
  description = "Number of iterations to generate logs"
  type        = number
  default     = 10000  # Increase for larger logs
}

variable "log_message_size" {
  description = "Size of each log message in characters"
  type        = number
  default     = 1000   # Increase for larger messages
}
```

To override variables in Schematics:
1. Go to workspace settings
2. Add variables under **Variables** section
3. Set `log_iterations` and `log_message_size` as needed

## How It Works

1. **Null Resources**: Uses `null_resource` with `local-exec` provisioners to execute shell commands
2. **Bash Loops**: Each resource runs nested loops to generate repetitive log entries
3. **Random Data**: Includes random hex strings, UUIDs, and base64 encoded data
4. **Timestamps**: Every log entry includes timestamps for realism
5. **Structured Output**: Logs include JSON metadata and structured information
6. **Dependencies**: Resources depend on each other to ensure sequential execution
7. **Always Run**: Uses `timestamp()` trigger to ensure resources run on every apply

## Log Content

The generated logs include:
- Instance identifiers
- Iteration counters
- Timestamps (multiple formats)
- Random hexadecimal data
- UUIDs
- Base64 encoded random data
- JSON metadata
- Verbose descriptive text
- Structured log entries

## Viewing Logs in Schematics

1. Navigate to your workspace in IBM Cloud Schematics
2. Click on **Jobs** tab
3. Select the apply job
4. View logs in the **Logs** section
5. Logs can be downloaded for offline analysis

## Important Notes

- **Execution Time**: Generating 100MB+ of logs will take several minutes
- **Resource Limits**: Ensure your Schematics workspace has sufficient resources
- **Log Retention**: IBM Cloud Schematics retains logs for a limited time
- **Cost**: This template uses only null resources, so there's no infrastructure cost
- **Performance**: The execution time depends on the Schematics runner performance

## Cleanup

To destroy the resources (null resources don't create actual infrastructure):

```bash
# Using CLI
ibmcloud schematics destroy --id $WORKSPACE_ID

# Or in console
# Navigate to workspace → Actions → Destroy resources
```

## Troubleshooting

### Logs not reaching 100MB
- Increase `log_iterations` variable
- Increase `log_message_size` variable
- Add more null_resource instances
- Increase iterations in bash loops

### Execution timeout
- Reduce the number of iterations
- Split into multiple workspaces
- Increase Schematics timeout settings

### Out of memory errors
- Reduce the number of concurrent resources
- Add more `depends_on` relationships to serialize execution

## License

This template is provided as-is for testing purposes.