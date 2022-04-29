sudo apt install build-essential zlib1g-dev libssl-dev libpam0g-dev libselinux1-dev libkrb5-dev -y
sudo mkdir /var/lib/sshd
sudo chmod -R 700 /var/lib/sshd/
sudo chown -R root:sys /var/lib/sshd/

wget --no-cache -c https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.9p1.tar.gz
tar -xvzf openssh-8.9p1.tar.gz -C /tmp/
sleep 1
dirName="/tmp/openssh-8.9p1"
cd -- "$dirName"
pwd
ls -la

./configure --with-kerberos5 --with-md5-passwords --with-pam --with-selinux --with-privsep-path=/var/lib/sshd/ --sysconfdir=/etc/ssh
make
sudo make install
sudo sed 's/sbin\/sshd/local\/sbin\/sshd/g' /etc/systemd/system/sshd.service | sudo tee /etc/systemd/system/sshd.service.bak
sudo mv /etc/systemd/system/sshd.service.bak /etc/systemd/system/sshd.service
sudo cd /usr/sbin
# Back up existing
sudo mv /usr/sbin/sshd /usr/sbin/sshd.bak                 
sudo cp /usr/local/sbin/sshd /usr/sbin/sshd
