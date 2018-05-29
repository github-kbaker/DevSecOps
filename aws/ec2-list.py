#!/usr/bin/env python

# ec2-list.py in https://github.com/wilsonmar/DevSecOps/new/master/aws
# SCRIPT STATUS: UNDER CONSTRUCTION.
# This List EC2 instances described in the hands-on blog at
#    https://cloudacademy.com/blog/boto-python-automate-aws-services/ 

# Instead of typing, copy this command to run in the console within the cloud:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/aws/ec2-list.py)"

import boto3
ec2 = boto3.resource('ec2')
for instance in ec2.instances.all():
    print instance.id, instance.state
