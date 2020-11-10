FROM jenkins/jenkins:lts
USER root
RUN apt-get update && \
apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \ 
apt-get update && \ 
apt-get -y install docker-ce 
RUN apt-get install -y docker-ce
RUN groupmod -g 993 docker
RUN usermod -a -G docker jenkins
USER jenkins
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false 
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yml
COPY JENKINS_ADMIN_ID /run/secrets/JENKINS_ADMIN_ID
COPY JENKINS_ADMIN_PASSWORD /run/secrets/JENKINS_ADMIN_PASSWORD
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY casc.yml /var/jenkins_home/casc.yml
