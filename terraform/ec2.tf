data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1

    # Install Node.js 20
    dnf install -y nodejs git
    node --version

    # Clone the repository
    cd /opt
    git clone https://github.com/${var.github_repo}.git app
    cd app

    # Create systemd service
    cat > /etc/systemd/system/snake-game.service <<'UNIT'
    [Unit]
    Description=Snake Game Node.js Server
    After=network.target

    [Service]
    Type=simple
    WorkingDirectory=/opt/app
    ExecStart=/usr/bin/node server.js
    Restart=on-failure
    RestartSec=5
    Environment=PORT=8080
    StandardOutput=journal
    StandardError=journal

    [Install]
    WantedBy=multi-user.target
    UNIT

    systemctl daemon-reload
    systemctl enable snake-game
    systemctl start snake-game
  EOF

  user_data_replace_on_change = true

  tags = { Name = "${var.service_name}-ec2" }
}

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app.id
  port             = var.app_port
}
