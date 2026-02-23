variable "log_iterations" {
  description = "Number of iterations to generate logs (higher = larger logs)"
  type        = number
  default     = 10000
  
  validation {
    condition     = var.log_iterations > 0 && var.log_iterations <= 100000
    error_message = "log_iterations must be between 1 and 100000"
  }
}

variable "log_message_size" {
  description = "Size of each log message in characters"
  type        = number
  default     = 1000
  
  validation {
    condition     = var.log_message_size > 0 && var.log_message_size <= 10000
    error_message = "log_message_size must be between 1 and 10000"
  }
}

variable "resource_count_tier1" {
  description = "Number of null_resource instances for log generator 1"
  type        = number
  default     = 100
}

variable "resource_count_tier2" {
  description = "Number of null_resource instances for log generator 2"
  type        = number
  default     = 100
}

variable "resource_count_tier3" {
  description = "Number of null_resource instances for log generator 3"
  type        = number
  default     = 100
}

variable "resource_count_tier4" {
  description = "Number of null_resource instances for log generator 4"
  type        = number
  default     = 50
}

variable "iterations_per_resource" {
  description = "Number of iterations per resource instance"
  type        = number
  default     = 100
}