variable "rules" {
  type = list(object({
    port        = number
    proto       = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      port        = 22
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 6379
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]


}

variable "instance_keypair" {
  default = "rediskeypair"
}


variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-0cd59ecaf368e5ccf"
  }
}


