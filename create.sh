#!/bin/bash
#
# Create a new vhost for Apache 2 on Linux systems.
#

# Errors are fatal
set -e

echo "# What is the site domain?"
read MY_DOMAIN

echo "# Creating the Directory Structure"
sudo mkdir -p /var/www/$MY_DOMAIN/public_html

echo "# Granting Permissions"
sudo chown -R $USER:$USER /var/www/$MY_DOMAIN/public_html
sudo chmod -R 755 /var/www

echo "# Creating demo page"
cat <<EOF >/var/www/$MY_DOMAIN/public_html/index.html
<html>
  <head>
    <title>Welcome to $MY_DOMAIN!</title>
  </head>
  <body>
    <h1>Success! The $MY_DOMAIN virtual host is working!</h1>
  </body>
</html>
EOF

echo "# Creating Virtual Host File"
cat <<EOF >/etc/apache2/sites-available/$MY_DOMAIN.conf
<VirtualHost *:80>
    ServerAdmin admin@$MY_DOMAIN
    ServerName $MY_DOMAIN
    ServerAlias www.$MY_DOMAIN
    DocumentRoot /var/www/$MY_DOMAIN/public_html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

echo "# Enabling the New Virtual Host File"
sudo a2ensite $MY_DOMAIN.conf
sudo a2dissite 000-default.conf

echo "# Restarting Apache"
sudo systemctl restart apache2

while true; do
    read -p "Do you wish to set up local hosts file (Optional)? " yn
    case $yn in
        [Yy]* ) echo "127.0.0.1       $MY_DOMAIN" | sudo tee -a /etc/hosts; break;;
        [Nn]* ) break;;
        * ) echo "Please answer Y or N.";;
    esac
done

echo "###"
echo "# All done! Check your new virtual host: http://$MY_DOMAIN"
echo "###"
exit