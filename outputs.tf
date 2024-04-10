output "RedisMaster" {
  description = "RedisMaster"
  value       = join("", ["http://", aws_instance.redis-master.public_ip])
}

output "RedisSlave" {
  description = "RedisMaster"
  value       = join("", ["http://", aws_instance.redis-slave.public_ip])
}
output "Rediscli" {
  description = "RedisMaster"
  value       = join("", ["http://", aws_instance.redis-cli.public_ip])
}
output "Time-Date" {
  description = "Date/Time of Execution"
  value       = timestamp()
}
