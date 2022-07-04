# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "names" {
  description = "The names of the secrets to create"
  type        = list(string)
}
variable "path" {
  description = "The path to organize secrets"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "length" {
  description = "The length of the password to be generated"
  type        = number
  default     = 15
}
variable "min_lower" {
  description = "Minimum number of lowercase characters"
  type        = number
  default     = 1
}
variable "min_numeric" {
  description = "Minimum number of numeric characters"
  type        = number
  default     = 1
}
variable "min_special" {
  description = "Minimum number of special characters"
  type        = number
  default     = 1
}
variable "min_upper" {
  description = "Minimum number of uppercase characters"
  type        = number
  default     = 1
}
variable "override_special" {
  description = "Limit special characters to these"
  type        = string
  default     = "_%!"
}
variable "special" {
  description = "Whether or not to include special characters in random password string"
  type        = bool
  default     = true
}
