s3-buckets.md

From https://stackify.com/what-is-aws-cli/

Deleting an S3 Bucket
The Amazon S3 service is Amazon’s Simple Storage Device. It provides basic online data storage in a pay-for-what-you-use plan. The data are stored in buckets. When using the standard GUI, deleting a bucket with several files and folders can be somewhat time-consuming. By using the AWS CLI, you can perform this task in just a few seconds with a single command:

$ aws s3 rb s3://bucket-name --force
