data "aws_subnet" "selected" {
  id = var.pub_subnet_id
}

data "aws_route53_zone" "internal" {
  private_zone = true
  vpc_id       = data.aws_subnet.selected.vpc_id
  zone_id      = var.route53_zone_id
}

resource "aws_key_pair" "this" {
  key_name   = "${var.resource_prefix}keypair"
  public_key = file("sshaccess/${var.key_name}")
}

resource "aws_eip" "bastion" {
  vpc = true
  tags = merge(
    {
      "Name" = "${var.resource_prefix}IPBastion"
    },
    local.tags,
  )
}

data "template_cloudinit_config" "bastion" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = <<EOF
hostname: ${lower(format("%sVMBST01", var.resource_prefix))}
fqdn: ${lower(format("%sVMBST01", var.resource_prefix))}.${data.aws_route53_zone.internal.name}
    EOF
  }
  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/usr/bin/env bash
set -x
sudo apt-get update -y
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
sudo chmod +x openvpn-install.sh
export AUTO_INSTALL=y
./openvpn-install.sh
    EOF
  }
}

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.selected.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.bastion.id
  key_name               = aws_key_pair.this.id
  user_data_base64       = data.template_cloudinit_config.bastion.rendered
  source_dest_check      = false
  tags = merge(
    {
      "Name"     = "${var.resource_prefix}-VMBST01"
      "Function" = "bastion"
    },
    local.tags,
  )
  volume_tags = merge(
    {
      "Name" = format("%sVMBST01", var.resource_prefix)
    },
    local.tags,
  )
  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}

resource "aws_route53_record" "bastion" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = lower(aws_instance.bastion.tags["Name"])
  type    = "A"
  ttl     = "300"
  records = [aws_instance.bastion.private_ip]
}
