provider "null" {}

variable "users" {
  type = list(object({
    name = string 
    age  = number
  }))
  
  default = [
    { name = "user1", age = 30 },
    { name = "user2", age = 25 },
    { name = "user3", age = 40 },
  ]
}

output "users_with_tags" {
  value = [ for user in var.users : {upper(user.name) = upper(user.age)}]
}