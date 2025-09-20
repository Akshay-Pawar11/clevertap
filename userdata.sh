#!/bin/bash
set -xe
apt-get update -y
apt-get upgrade -y

apt-get install -y apache2 php php-mysql mariadb-client wget tar

systemctl enable apache2
systemctl start apache2

wget https://wordpress.org/latest.tar.gz -P /tmp
tar -xzf /tmp/latest.tar.gz -C /tmp
cp -r /tmp/wordpress/* /var/www/html/

cat > /var/www/html/wp-config.php <<EOL
<?php
define( 'DB_NAME', '${db_name}' );
define( 'DB_USER', '${db_user}' );
define( 'DB_PASSWORD', '${db_password}' );
define( 'DB_HOST', '${db_host}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
EOL

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
rm -f /var/www/html/index.html
systemctl restart apache2