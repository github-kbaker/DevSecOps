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

# Attach MAVEN to S3 bucket by S3 > 'create public' > download via wget > and install
tar -zxvf apache-maven-3.3.9-bin.tar.gz
gunzip apache-maven-3.3.9-bin.tar.gz
mv ~/apache-maven-3.3.9 /opt
sudo chown -R root:root /opt/apache-maven-3.3.9
sudo ln -s /opt/apache-maven-3.3.9 /opt/apache-maven
echo 'export PATH=$PATH:/opt/apache-maven/bin' | sudo tee -a /etc/profile
source /etc/profile

# Get the NODEJS here https://nodejs.org/en/download/package-manager/
# NPM (Node package manager)
# Run `npm i npm@latest -g` to upgrade your npm version
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs
sudo yum install gcc-c++ make

# Verify NODEJS and NPM installed
node -v
npm -v

# Replace recompile deprecated maven packages (i.e. gulp with gulp-webpack, etc) and rerun 'mvn clean..'
npm i gulp-webpack
npm i pug
npm i minimatch
npm i graceful-fs
npm i tough-cookie
npm i gulp-util
npm i gulp-header
npm i connect

# After reboot, recompiling deprecated maven packages below, I was able to successfully build maven
# for i in `cat /tmp/npm-i.txt`;do npm i $i;sleep 1;done
# [root@ip-172-31-45-126 api]# cat /tmp/npm-i.txt
npm i connect
npm i minimatch
npm i minimatch
npm i minimatch
npm i tough-cookie
npm i minimatch
npm i graceful-fs

# Troubleshooting 'mvn clean install package' I have noticed frequently the below errors:
#   “com.capitalona.dashboard:UI  Failure” 
# -        Bower install (keyword in the error message)
# -        npm install (keyword in the error message)
# -        npm build (or) ./lib/engine.io (keyword in the error message)
# https://github.com/capitalone/Hygieia/issues/1817
# Troubleshooting suggests removing delete node_modules, dist and bower_components folders for resolving the UI error

# Resolutions: re-install 'Bower and NPM' in ../UI/ directory the rerun ' mvn clean install package'

# GOTO hygieia directory, run git clone and then 'mvn clean install package'
cd /opt/hygieia
git clone https://github.com/capitalone/hygieia
mvn clean install package   # re-runnable and very useful in troubleshooting

# Download and install mongo db from the below url based on the OS flavour you used.
https://www.mongodb.com/download-center#previous

# Create a mongodb-org-3.4.repo file  under /etc/yum.repos.d/  and copy/paste the below lines in the 
# file(mongodb-org-3.4.repo). It is latest Database
vi /etc/yum.repos.d/mongodb-org-3.4.repo
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc

# Install mongodb
sudo yum install -y mongodb-org

# Configure SELINUX for /etc/selinux/config
semanage port -a -t mongod_port_t -p tcp 27017
SELINUX=disabled

# Validate mongodb status
service mongodb status/start/restart/stop









OLD PATH (redeveloping)
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
# Run `npm i npm@latest -g` to upgrade your npm version
 

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
