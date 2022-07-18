# Cloudlab Terraform Modules
This holds Terraform modules written for AWS practice deployments.
These modules are called by:  
https://github.com/AgentWong/cloudlab-terraform-live  
Some modules also call Ansible playbooks in this repository:  
https://github.com/AgentWong/cloudlab-ansible

## Structure
1. Base modules
    - Smallest modules that do not call other modules.
2. Composite modules
    - Calls a number of modules and creates other resources to form a coherent "service"
    - LAMP stack
        - Calls "asg" module to create an Auto-Scaling Group
        - Calls "alb" module to create an Application Load Balancer
        - Calls "rds-sql" module to create a MySql database on RDS.
        - Calls "secrets-manager" module to create a random password and store that in Secrets Manager for RDS to use.