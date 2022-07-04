# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_name" {
  description = "The name to use for the database"
  type        = string
}
variable "db_username" {
  description = "The username for the database"
  type        = string
}
variable "db_password" {
  description = "The password for the database"
  type        = string
}
variable "engine" {
  description = "The engine for the database"
  type        = string
}
variable "storage" {
  description = "The storage size for the database"
  type        = string
}
variable "instance_class" {
  description = "The instance class for the database"
  type        = string
}
variable "identifier_prefix" {
  description = "The actual name to use for the database"
  type        = string
}