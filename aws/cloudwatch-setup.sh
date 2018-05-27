# From https://linuxacademy.com/cp/modules/view/id/163

######## Install CloudWatch Agent ############
wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip
unzip AmazonCloudWatchAgent.zip
sudo ./install.sh

######## Configure CloudWatch Agent ############
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

######## Start CloudWatch Agent ###############
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:<configuration-file-path> -s
