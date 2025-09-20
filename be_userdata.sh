#!/bin/bash

sudo yum update -y
sudo yum install -y python3 python3-pip unzip

mkdir -p /home/ec2-user/simple-backend
chown -R ec2-user:ec2-user /home/ec2-user/simple-backend
chmod 755 /home/ec2-user/simple-backend
cd /home/ec2-user/simple-backend

python3 -m venv myenv
source myenv/bin/activate

aws s3 cp s3://my-test-clevertap/simple-app/simple-backend/ . --recursive

pip3 install --upgrade pip
pip3 install -r requirements.txt

nohup python3 app.py &
