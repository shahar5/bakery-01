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

# Install git & configure key pair
sudo yum install -y -q git
sudo systemctl enable git
ssh-keygen -t rsa -b 4096
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# Run jenkins container
echo -e "\nPulling Jenkins container\n"
sudo docker pull -q jenkins/jenkins:lts-centos7
sudo docker run --publish 11000:8080 -d --name jenkins-centos07 jenkins/jenkins:lts-centos7
echo -e "\nJenkins initial-Admin-Password is -"
sudo docker exec jenkins-centos07 cat /var/jenkins_home/secrets/initialAdminPassword