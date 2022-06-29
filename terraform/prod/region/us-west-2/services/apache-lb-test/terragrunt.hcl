terraform {
  source = "../../../../../modules//composite/services/apache-lb-test"
}
include "root" {
  path = find_in_parent_folders()
}
inputs = {
  # EC2
  user_data = <<EOF
    #!/bin/bash
    yum -y install httpd git
    service httpd start
    echo "This is coming from default apache page" >> /var/www/html/index.html
    cd
    git clone https://github.com/PacktPublishing/Mastering-AWS-System-Administration.git
    cd Mastering-AWS-System-Administration/Chapter4-Scalable-compute-capacity-in-the-cloud-via-EC2/html/
    cp -avr work /var/www/html/
  EOF
  instance_name = "prod"
  ami_owner = ""
  ami_name = ""
  subnet_id = ""

  # ALB
  alb_name = ""
  public_subnets = ""
  vpc_id = ""
}
