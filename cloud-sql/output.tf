output "db-user" {
  value = google_sql_user.users.name
}

output "db-pass" {
  value = random_password.password.result
}