resource "aws_instance" "ec2_instance" {
  instance_type = var.web_instance_type
  ami           = var.base_ami_id

  # Associe a sub-rede e o grupo de segurança à instância
  subnet_id              = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.allow_ports.id]

  key_name                    = aws_key_pair.deployer.key_name # Usando o par de chaves criado
  associate_public_ip_address = true                           # Garantindo que a instância tenha um IP público

  # Define o script de instalação no campo user_data
  user_data = <<-EOF
#!/bin/bash

# https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-quickstart/
# https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-scalable/

sudo apt-get -y update
sudo apt-get -y install apt-transport-https
sudo apt-get -y install debconf-utils
sudo add-apt-repository -y universe
sudo apt-get -y update

sudo curl -sL https://prosody.im/files/prosody-debian-packages.key -o /etc/apt/keyrings/prosody-debian-packages.key
echo "deb [signed-by=/etc/apt/keyrings/prosody-debian-packages.key] http://packages.prosody.im/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/prosody-debian-packages.list
sudo apt-get -y install lua5.2

curl -sL https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo "deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/" | sudo tee /etc/apt/sources.list.d/jitsi-stable.list

sudo apt-get -y update

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 10000/udp
sudo ufw allow 22/tcp
sudo ufw allow 3478/udp
sudo ufw allow 5349/tcp
sudo ufw --force enable

echo "jitsi-meet jitsi-meet/jvb-serve boolean false" | sudo debconf-set-selections
echo "jitsi-meet-web-config jitsi-meet/cert-choice select Generate a self-signed certificate (You will later get a chance to obtain a Let's Encrypt certificate)" | sudo debconf-set-selections
echo "jitsi-meet-web-config jitsi-meet/jaas-choice boolean false" | sudo debconf-set-selections
echo "jitsi-meet-prosody jitsi-videobridge/jvb-hostname string ${var.subdomain}.${var.domain}" | sudo debconf-set-selections
echo "jitsi-videobridge jitsi-videobridge/jvb-hostname string ${var.subdomain}.${var.domain}" | sudo debconf-set-selections

sudo apt-get -y install jitsi-meet

echo "org.jitsi.videobridge.xmpp.user.shard.DISABLE_CERTIFICATE_VERIFICATION=true" | sudo tee -a /etc/jitsi/videobridge/sip-communicator.properties

sudo systemctl restart prosody
sudo systemctl restart jitsi-videobridge2
sudo systemctl restart jicofo
EOF

  tags = {
    Name = "${var.project}-web"
  }
}