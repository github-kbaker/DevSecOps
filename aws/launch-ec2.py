#/usr/bin/python
# SCRIPT STATUS: UNDER CONSTRUCTION.
# This performs the commands described in the hands-on blog at
#    https://cloudacademy.com/blog/boto-python-automate-aws-services/ 

# Instead of typing, copy this command to run in the console within the cloud:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/aws/launch-ec2.py)"

import boto.ec2
conn = boto.ec2.connect_to_region("us-west-2")
conn.run_instances(
    'ami-6ac2a85a',
    key_name='nitheesh_oregon',
    instance_type='t1.micro',
    security_groups=['nitheesh_oregon']
)
