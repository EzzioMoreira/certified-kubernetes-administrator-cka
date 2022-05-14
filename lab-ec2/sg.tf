resource "aws_security_group" "allow_access" {
  vpc_id      = "vpc-0383c9825b17dfef1"
  name        = "allow_acess"
  description = "Allow ports cluster kubernetes inbound traffic"

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow api-server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "allow_k8s" {
  security_group_id        = aws_security_group.allow_access.id
  description              = "Allow ports kubernetes between instances"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = -1
  source_security_group_id = aws_security_group.allow_access.id
}
