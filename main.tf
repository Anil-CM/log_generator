terraform {
  required_version = ">= 1.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

# Generate a large string for logging
locals {
  # Create a base message that will be repeated
  base_message = "This is a log message designed to generate large output for IBM Cloud Schematics. It contains various information including timestamps, iteration numbers, and padding to increase size. "
  
  # Pad the message to reach desired size
  padded_message = join("", [
    for i in range(var.log_message_size / length(local.base_message)) : local.base_message
  ])
  
  # Create multiple log entries
  log_entries = [
    for i in range(var.log_iterations) : format(
      "[%05d] %s | Timestamp: %s | Random: %s\n",
      i,
      local.padded_message,
      timestamp(),
      md5("${i}-${timestamp()}")
    )
  ]
}

# Null resource to generate logs through local-exec
resource "null_resource" "log_generator_1" {
  count = var.resource_count_tier1
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "=========================================="
      echo "Log Generator 1 - Instance ${count.index}"
      echo "=========================================="
      for i in $(seq 1 ${var.iterations_per_resource}); do
        echo "[Instance-${count.index}] [Iteration-$i] $(date '+%Y-%m-%d %H:%M:%S') - Generating large log output for IBM Cloud Schematics testing. This message is repeated multiple times to increase log file size. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      done
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  
  triggers = {
    always_run = timestamp()
  }
}

resource "null_resource" "log_generator_2" {
  count = var.resource_count_tier2
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "=========================================="
      echo "Log Generator 2 - Instance ${count.index}"
      echo "=========================================="
      for i in $(seq 1 ${var.iterations_per_resource}); do
        echo "[Instance-${count.index}] [Iteration-$i] Processing data chunk: $(openssl rand -hex 256)"
        echo "[Instance-${count.index}] [Iteration-$i] Additional context: This is a comprehensive logging system designed to test IBM Cloud Schematics log handling capabilities. The system generates structured log entries with timestamps, instance identifiers, and iteration counters. Each log entry contains substantial text content to ensure the total log output reaches the target size of 100MB or more."
      done
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  
  depends_on = [null_resource.log_generator_1]
  
  triggers = {
    always_run = timestamp()
  }
}

resource "null_resource" "log_generator_3" {
  count = var.resource_count_tier3
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "=========================================="
      echo "Log Generator 3 - Instance ${count.index}"
      echo "=========================================="
      for i in $(seq 1 ${var.iterations_per_resource}); do
        echo "[Instance-${count.index}] [Iteration-$i] $(date '+%Y-%m-%d %H:%M:%S.%N') - Extended log entry with detailed information about the current execution context. This includes system metadata, execution parameters, and verbose debugging information that would typically be captured during infrastructure provisioning operations."
        echo "[Instance-${count.index}] [Iteration-$i] Metadata: {\"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\", \"instance\": ${count.index}, \"iteration\": $i, \"random_id\": \"$(uuidgen)\"}"
      done
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  
  depends_on = [null_resource.log_generator_2]
  
  triggers = {
    always_run = timestamp()
  }
}

resource "null_resource" "log_generator_4" {
  count = var.resource_count_tier4
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "=========================================="
      echo "Log Generator 4 - Instance ${count.index}"
      echo "=========================================="
      for i in $(seq 1 $((${var.iterations_per_resource} * 2))); do
        echo "[Instance-${count.index}] [Iteration-$i] Verbose output: $(cat /dev/urandom | base64 | head -c 500)"
        echo "[Instance-${count.index}] [Iteration-$i] Status: Processing | Phase: Execution | Stage: Provisioning | Component: Infrastructure | Layer: Compute | Region: Multi-Region | Environment: Production | Version: 1.0.0 | Build: $(date +%s)"
      done
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  
  depends_on = [null_resource.log_generator_3]
  
  triggers = {
    always_run = timestamp()
  }
}
