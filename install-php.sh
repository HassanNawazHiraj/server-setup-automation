confirm_php_version="n"

while [ "$confirm_php_version" = "n" ]; do
    read -p "Enter the PHP version you want to install (e.g., 8.1): " php_version
    
    # Verify PHP version with the user
    read -p "You have selected PHP version $php_version. This will install the package php${php_version}-fpm and php-mysql. Are you sure? (y/n/skip): " confirm_php_version
    
    if [ "$confirm_php_version" = "y" ]; then
        sudo add-apt-repository ppa:ondrej/php
        sudo apt update -y
        sudo apt upgrade -y
        # Install PHP
        sudo apt install php${php_version}-fpm php-mysql -y
        echo "PHP $php_version and php-mysql package will be installed."
    fi
    
done




# Ask user if they want to configure Nginx to use PHP
read -p "Do you want to configure Nginx to use PHP? (y/n): " configure_php

if [ "$configure_php" = "y" ]; then
    # Replace the placeholder with the actual PHP version
    sed "s/{{PHP_VERSION}}/$php_version/g" ./templates/nginx_default_php > default
    
    # Move the generated file to the sites-available directory
    sudo mv default /etc/nginx/sites-available/
    
    if [ ! -L /etc/nginx/sites-enabled/default ]; then
        # Enable the site
        sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
    else
        echo "Default site already enabled."
    fi
    
    # clear /var/www/html folder and create a new index.php file
    sudo rm -rf /var/www/html/*
    
    # create a new index.php file from ./templates/index.php
    cp ./templates/index.php /var/www/html/index.php
    
    # Restart Nginx
    sudo systemctl restart nginx
fi

# # Restart Nginx
sudo systemctl restart nginx