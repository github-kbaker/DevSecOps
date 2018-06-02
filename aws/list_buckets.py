#!/usr/bin/python

# list_buckets.py
# From https://www.youtube.com/watch?v=vP56l7qThNs&t=39m40s

import botocore
s = botocore.session.get_session()
s3 = s.create_client('s3', region_name='us-west-2')
for bucket in s3.list_buckets()['Buckets']:
    print("Bucket: {bucket}".format(bucket=bucket['Name']))
