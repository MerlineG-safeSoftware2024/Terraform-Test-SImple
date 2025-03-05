provider "aws" {
  region = "canada-central-1"  # Change this to your preferred AWS region
}
resource "aws_instance" "windows_instance" {
  ami           = "ami-0b221987f93a1dbfe"  # This is an example Windows Server 2019 AMI ID. Replace it with the correct one for your region
  instance_type = "t2.micro"  # Choose the desired EC2 instance type
  # Set up the Security Group to allow RDP (3389)
  vpc_security_group_ids = [aws_security_group.rdp_sg.id]
  # Key pair to access the instance (make sure to replace with your own key name)
  key_name = "merline_ec2_key"  # Replace with your key pair name
  # Windows Admin password generation
  tags = {
    Name = "WindowsInstance"
  }
  # Associate an Elastic IP if you need a static public IP
  associate_public_ip_address = true
}
resource "aws_security_group" "rdp_sg" {
  name        = "rdp-sg"
  description = "Allow RDP access to Windows EC2 instance"
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all IPs (be cautious with this in production)
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "instance_id" {
  value = aws_instance.windows_instance.id
}
output "public_ip" {
  value = aws_instance.windows_instance.public_ip
}
output "admin_password" {
  value = aws_instance.windows_instance.password_data
  sensitive = true  # This will hide the password in output, but it will still be available if needed.
}






