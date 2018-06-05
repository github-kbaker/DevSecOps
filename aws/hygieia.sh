#!/bin/bash -e

# This installs within EC2 instance Hygieia server, then configures it.
# sh -c "$(curl -fsSL https://github.com/github-kbaker/DevSecOps/blob/master/aws/hygieia.sh)"
# Following https://capitalone.github.io/Hygieia/setup.html

# git clone https://github.com/capitalone/Hygieia.git

            # https://capitalone.github.io/Hygieia/troubleshoot.html
            # https://github.com/bbyars/hygieia/issues/167#issuecomment-385420564
            
echo "yum install java-1.8.0-openjdk"    
java -version
