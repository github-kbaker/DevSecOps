#!/usr/bin/env python
# List EC2 instances.
# ec2-list.py in https://github.com/wilsonmar/DevSecOps/new/master/aws
import boto3
ec2 = boto3.resource('ec2')
for instance in ec2.instances.all():
    print instance.id, instance.state
