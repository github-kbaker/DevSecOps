#!/bin/bash -e

# Part I
# This script installs Hygieia server within EC2 instance, then configures it.
# Instead of typing at EC2 instance cli, copy the commands to run in console within the cloud:
# sh -c "$(curl -fsSL https://github.com/github-kbaker/DevSecOps/blob/master/aws/hygieia.sh)"

# Install Git - Install Git for your platform. For installation steps, see the Git documentation.
# Install Java - Version 1.8 is recommended
# Install Maven - Version 3.3.9 and above are recommended

yum install git -y

# Attach to S3 bucket by S3 > 'create public' and install java
wget https://s3.us-east-2.amazonaws.com/s3.console.aws.amazon-clsx/jdk-8u45-linux-x64.tar.gz
cd /opt/java
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
cd /opt/
git clone https://github.com/capitalone/hygieia
cd /opt/hygieia
mvn clean install package   # end of P1  re-runnable and very useful in troubleshooting

# Part II 
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

# start the mongod process by issuing the following command and ensure that MongoDB will start following a system reboot
sudo service mongod start
sudo chkconfig mongod on

# Validate mongodb status
sudo service mongod status

# Validate DB Configuration and log files are in the below section:
ls /var/lib/mongo
ls /var/log/mogodb
ls /usr/bin/        # mongo DB commands exist here which are useful for Hygieia.

# Start a mongo shell on the same host machine as the mongod
mongo --host 127.0.0.1:27017

cd /usr/bin/
mongo
> use dashboarddb
> db.createUser(
                 {
                   user: "dashboarduser",
                   pwd: "dbpassword",
                   roles: [
                      {role: "readWrite", db: "dashboard"}
                           ]
                   })
> show users                   

# Generate dashboard.properties file
# Run api.jar in Hygieia
java -jar api.jar --spring.config.location=/opt/hygieia/api/dashboard.properties -Djasypt.encryptor.password=hygieiasecret

# Output as seen below
# ...
# 2018-06-08 23:21:34,309 INFO  s.d.s.w.r.o.CachingOperationNameGenerator - Generating unique operation named: refreshServiceUsingGET_1
# 2018-06-08 23:21:34,335 INFO  s.d.s.w.r.o.CachingOperationNameGenerator - Generating unique operation named: teamsByCollectorUsingGET_1
# 2018-06-08 23:21:34,337 INFO  s.d.s.w.r.o.CachingOperationNameGenerator - Generating unique operation named: teamsByCollectorPageUsingGET_1
# 2018-06-08 23:21:34,417 INFO  s.d.s.w.r.o.CachingOperationNameGenerator - Generating unique operation named: qualityDataUsingGET_1
# 2018-06-08 23:21:34,439 INFO  s.d.s.w.r.o.CachingOperationNameGenerator - Generating unique operation named: createGitHubv3UsingPOST_1
# 2018-06-08 23:21:34,441 INFO  s.d.s.w.r.o.CachingOperationNameGenerator - Generating unique operation named: searchUsingGET_2
# 2018-06-08 23:21:34,515 INFO  o.a.coyote.http11.Http11NioProtocol - Initializing ProtocolHandler ["http-nio-8080"]
# 2018-06-08 23:21:34,547 INFO  o.a.coyote.http11.Http11NioProtocol - Starting ProtocolHandler ["http-nio-8080"]
# 2018-06-08 23:21:34,566 INFO  o.a.tomcat.util.net.NioSelectorPool - Using a shared selector for servlet write/read
# 2018-06-08 23:21:34,624 INFO  o.s.b.c.e.t.TomcatEmbeddedServletContainer - Tomcat started on port(s): 8080 (http)
# 2018-06-08 23:21:34,628 INFO  com.capitalone.dashboard.Application - Started Application in 23.449 seconds (JVM running for 25.316)

# Final states follow.  
# Some additional required modules installs required gulp-angular-templatecache, gulp-change
 npm install --save gulp-angular-templatecache
 
# Audit for build errors that continue to occur -- this never worked for me
npm audit fix --force

# ORDER is important.  Attempt removing and reinstalling --works
rm -rf node_modules
rm -rf bower_components
bower install bower.json --allow-root
npm install –global install

# Run UI in Hygieia:  Command: cd <Hygieia_folder/UI>  --works
gulp serve &
 
# Successfull gulp messages follow 
#	[23:29:56] Starting 'build'...
#	[23:29:56] Starting 'clean'...
#	[23:29:56] Finished 'clean' after 13 ms
#	[23:29:56] Starting 'assets'...
#	[23:29:56] Starting 'themes'...
#	[23:29:56] Starting 'fonts'...
#	[23:29:56] Starting 'js'...
#	[23:29:56] Starting 'views'...
#	[23:29:56] Starting 'test-data'...
#	[23:30:07] Finished 'assets' after 11 s
#	[23:30:07] Finished 'themes' after 11 s
#	[23:30:07] Finished 'test-data' after 11 s
#	[23:30:07] Finished 'views' after 11 s
#	[23:30:07] Finished 'js' after 11 s
#	[23:30:08] Finished 'fonts' after 12 s
#	[23:30:08] Starting 'html'...
#	[23:30:08] gulp-inject 1 files into index.html.
#	[23:30:08] gulp-inject 155 files into index.html.
#	[23:30:08] Finished 'html' after 217 ms
#	[23:30:08] Finished 'build' after 12 s
#	[23:30:08] Starting 'serve'...
#	[23:30:08] Finished 'serve' after 169 ms
#	[BS] Local URL: http://localhost:3000
#	[BS] External URL: http://172.31.47.199:3000
#	[BS] Serving files from: dist/
  

