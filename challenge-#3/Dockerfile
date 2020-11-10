FROM jenkins/jenkins

# Disable Jenkins initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# JCasC config file
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yml

# Secrets files
COPY JENKINS_ADMIN_ID /run/secrets/JENKINS_ADMIN_ID
COPY JENKINS_ADMIN_PASSWORD /run/secrets/JENKINS_ADMIN_PASSWORD

# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# JCasC config file
COPY casc.yml /var/jenkins_home/casc.yml