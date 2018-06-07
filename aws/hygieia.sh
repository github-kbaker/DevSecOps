#!/bin/bash -e

# This script installs Hygieia server within EC2 instance, then configures it.

# Instead of typing at EC2 instance cli, copy this command to run in the console within the cloud:
# sh -c "$(curl -fsSL https://github.com/github-kbaker/DevSecOps/blob/master/aws/hygieia.sh)"

# Referencing https://capitalone.github.io/Hygieia/setup.html, this routine will clone Hygieia to local EC2 instance
# git clone https://github.com/capitalone/Hygieia.git

# Referencing capitalone.github, this routine uses GitHub Collector for a Private Repo
# https://capitalone.github.io/Hygieia/troubleshoot.html
# https://github.com/bbyars/hygieia/issues/167#issuecomment-385420564

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

# This routine start up API.JAR via java
/home/jbaker/Hygieia/api/target]# java -jar api.jar --spring.config.name=api --spring.config.name=dashboard.properties --spring.config.location=/opt/git/Hygieia/api/dashboard.properties
