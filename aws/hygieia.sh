#!/bin/bash -e

# This script installs Hygieia server within EC2 instance, then configures it.

# Instead of typing at EC2 instance cli, copy this command to run in the console within the cloud:
# sh -c "$(curl -fsSL https://github.com/github-kbaker/DevSecOps/blob/master/aws/hygieia.sh)"

yum install git -y

# Attach to S3 bucket by S3 > 'create public' and install java
wget https://s3.us-east-2.amazonaws.com/s3.console.aws.amazon-clsx/jdk-8u45-linux-x64.tar.gz
tar -zxvf jdk-8u45-linux-x64.tar.gz
export JAVA_HOME=/opt/java/jdk1.8.0_45/
export JRE_HOME=/opt/java/jdk1.8.0._45/jre
export PATH=$PATH:/opt/java/jdk1.8.0_45/bin:/opt/java/jdk1.8.0_45/jre/bin

# Referencing https://capitalone.github.io/Hygieia/setup.html, this routine will clone Hygieia to local EC2 instance
# git clone https://github.com/capitalone/Hygieia.git


# Referencing capitalone.github, this routine uses GitHub Collector for a Private Repo
# https://capitalone.github.io/Hygieia/troubleshoot.html
# https://github.com/bbyars/hygieia/issues/167#issuecomment-385420564

# Java Install (v.1.8 above)

# Install pre-requisites as follows via root user
# Install Apache Maven (v3.1.2 above) update .bash_profile
# Advanced installation reference https://www.vultr.com/docs/how-to-install-apache-maven-3-5-on-centos-7
wget  http://mirror.olnevhost.net/pub/apache/maven/binaries/apache-maven-3.2.1.bin.tar.gz
tar -xvf apache-maven-3.2.1-bin.tar.gz
export M2_HOME=/usr/local/apache-maven/apache-maven-3.2.1
export M2=$M2_HOME/bin
export PATH=$M2:$PATH
mvn -version

# Install NodeJs (NVM-node version Manger)
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

# NPM (Node package manager)

# GULP Install
npm install gulp

# Bower Install
npm install bower

# This routine adds the mongodb.repo
vim /etc/yum.repos.d/mongodb.repo

# This routine will install mongodb
yum install mongo

# This routine performs java install reference link https://www.linode.com/docs/development/java/install-java-on-centos/
echo "yum install java-1.8.0-openjdk"  
sudo yum install java-1.7.0-openjdk-devel
java -version
export PATH=/usr/local/testing/jdk1.6.0_23/bin:$PATH

# This routine downloading and installing apache maven for centos
wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar xzf apache-maven-3.3.9-bin.tar.gz
mkdir /usr/local/maven
mv apache-maven-3.3.9/ /usr/local/maven/
alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-3.3.9/bin/mvn 1
alternatives --config mvn

# This routine will run Maven Build In the command line/terminal, run the following command from the \Hygieia directory
mvn clean install package

# This routine start up API.JAR via java ( curl http://localhost:8080 for testing connection )
/home/jbaker/Hygieia/api/target]# java -jar api.jar --spring.config.name=api --spring.config.name=dashboard.properties --spring.config.location=/opt/git/Hygieia/api/dashboard.properties
