# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "key_name" {
  description = "The keyname"
  type        = string
}
variable "public_key" {
  description = "The public key material"
  type        = string
}
