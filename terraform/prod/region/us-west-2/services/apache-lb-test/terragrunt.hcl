terraform {
  source = "../../../../../modules//composite/services/apache-lb-test"
}
include "root" {
  path = find_in_parent_folders()
}
include "region" {
  path = "${dirname(find_in_parent_folders())}/_env/regions/us-west-2.hcl"
}
dependency "setup" {
  config_path = "../../setup"
}
inputs = {
  # EC2
  ami_owner      = "amazon"
  ami_name       = "amzn-ami-hvm*"
  instance_count = "2"
  instance_name  = "prod-apache"
  key_name       = dependency.setup.outputs.key_name
  user_data      = <<EOF
    #!/bin/bash
    yum -y install httpd git
    service httpd start
    echo "This is coming from default apache page" >> /var/www/html/index.html
    cd
    git clone https://github.com/PacktPublishing/Mastering-AWS-System-Administration.git
    cd Mastering-AWS-System-Administration/Chapter4-Scalable-compute-capacity-in-the-cloud-via-EC2/html/
    cp -avr work /var/www/html/
  EOF

  # ALB
  alb_name   = "prod-alb"
  subnet1_id = dependency.setup.outputs.public_subnets[0]
  subnet2_id = dependency.setup.outputs.public_subnets[1]
  vpc_id     = dependency.setup.outputs.vpc_id
}
