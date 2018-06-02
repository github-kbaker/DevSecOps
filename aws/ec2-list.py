#!/usr/bin/env python

# SCRIPT STATUS: UNDER CONSTRUCTION
# ec2-list.py in https://github.com/wilsonmar/DevSecOps/new/master/aws
# This List EC2 instances described in the hands-on blog at
#    https://cloudacademy.com/blog/boto-python-automate-aws-services/ 

# To run locally: python3 ec2-list.py
# To run on server within AWS: copy this command to run in the console within the cloud:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/aws/ec2-list.py)"

import boto3
ec2 = boto3.resource('ec2')
print "at ec2-list.py"

for instance in ec2.instances.all():
    print "Instance: ", instance.id, instance.state 
