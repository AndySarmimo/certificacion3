output "database_hostname" {
   value = aws_db_instance.flashDB.address
}

output "database_port" {
   value = aws_db_instance.flashDB.port
}

output "database_db" {
   value = aws_db_instance.flashDB.name
}

output "database_user" {
   value = aws_db_instance.flashDB.username
}
output "database_pass" {
   value = random_password.db_master_pass.result
}