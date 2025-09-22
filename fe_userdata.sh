#!/bin/bash
dnf update -y
dnf install -y httpd -y

systemctl enable httpd

rm -rf /var/www/html/*

mkdir -p /var/www/html/homepage
aws s3 cp s3://my-test-clevertap/simple-app/simple-frontend/ /var/www/html/homepage/ --recursive
chown -R apache:apache /var/www/html/homepage
chmod -R 755 /var/www/html/homepage
systemctl start httpd