#!/bin/bash
sudo apt-get update
sudo apt-get install -y redis-server
sudo sed -i 's/^# bind 127.0.0.1 ::1/bind 0.0.0.0/' /etc/redis/redis.conf
sudo sed -i 's/^supervised no/supervised systemd/' /etc/redis/redis.conf
echo "slaveof ${aws_instance.redis_master.private_ip} 6379" | sudo tee -a /etc/redis/redis.conf
sudo systemctl restart redis.service