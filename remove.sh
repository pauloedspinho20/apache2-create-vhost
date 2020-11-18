#!/bin/bash
#
# Remove an existing vhost for Apache 2 on Linux systems.
#

# Errors are fatal
set -e

echo "# What is the site domain to remove?"
read MY_DOMAIN

echo "# Removing website and vhosts folder"
sudo rm -r /var/www/$MY_DOMAIN/
sudo rm -r /etc/apache2/sites-available/$MY_DOMAIN.conf
sudo a2dissite $MY_DOMAIN.conf
echo "# Restarting Apache"
sudo systemctl restart apache2

while true; do
    read -p "Do you wish to remove from local hosts file (Optional)? " yn
    case $yn in
        [Yy]* ) grep -v "^\127.0.0.1       $MY_DOMAIN=" /etc/hosts; break;;
        [Nn]* ) break;;
        * ) echo "Please answer Y or N.";;
    esac
done

echo "# All done!"
exit