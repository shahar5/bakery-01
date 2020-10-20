#!/usr/bin/bash
#
# Install Docker and Jenkins

# Install docker
echo -e "\nUpdating system..."
sudo yum update -q -y
echo -e "\nInstalling Docker...\n"
sudo yum install -q -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -q -y docker-ce docker-ce-cli containerd.io

# Start & check docker
sudo systemctl start --quiet docker
sudo systemctl is-active --quiet docker
if [ $? -eq 0 ]; then
	echo -e "\nDocker service is up and running!\n "
else
	echo -e "\nThere was an error running Docker\n"
fi

# Start docker on boot
sudo systemctl enable docker

# Install jenkins
echo -e "\nInstalling jenkins...\n"
sudo yum install -q -y wget
sudo wget -q -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import --quiet https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -q upgrade
sudo yum install -q -y jenkins java-1.8.0-openjdk-devel
sudo systemctl daemon-reload
echo "jenkins has been installed"

# Start & check jenkins
sudo systemctl start --quiet jenkins
sudo systemctl is-active --quiet jenkins
if [ $? -eq 0 ]; then
	echo -e "\nJenkins service is up and running!\n"
else
	echo -e "\nThere was an error running Jenkins\n"
fi
