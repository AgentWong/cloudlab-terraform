#!/bin/bash
yum -y install httpd git
service httpd start
cat > /var/www/html/index.html <<EOF
<h1>${server_text}</h1>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
EOF