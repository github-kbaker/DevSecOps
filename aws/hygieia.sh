#!/bin/bash -e

# This installs within EC2 instance Hygieia server, then configures it.
# sh -c "$(curl -fsSL https://github.com/github-kbaker/DevSecOps/blob/master/aws/hygieia.sh)"
# Following https://capitalone.github.io/Hygieia/setup.html

# git clone https://github.com/capitalone/Hygieia.git

            # https://capitalone.github.io/Hygieia/troubleshoot.html
            # https://github.com/bbyars/hygieia/issues/167#issuecomment-385420564
            
# This is the java install reference link https://www.linode.com/docs/development/java/install-java-on-centos/
echo "yum install java-1.8.0-openjdk"  
sudo yum install java-1.7.0-openjdk-devel
java -version
export PATH=/usr/local/testing/jdk1.6.0_23/bin:$PATH

# This is for downloading and installing apache maven for centos
wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar xzf apache-maven-3.3.9-bin.tar.gz
mkdir /usr/local/maven
mv apache-maven-3.3.9/ /usr/local/maven/
alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-3.3.9/bin/mvn 1
alternatives --config mvn

