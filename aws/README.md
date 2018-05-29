## Installation

Installation creates a folder under your $HOME folder with a file <tt>~/.aws/config</tt>.
Variables in the file are detailed in <a target="_blank" href="https://docs.aws.amazon.com/cli/latest/topic/config-vars.html#cli-aws-help-config-vars">Amazon's Configuration Variables</a>.

## Return Codes

As with all Bash commands, this command returns the result of the previous command:

   <tt>echo $?</tt>

Alternately, with PowerShell, the command is:

   <tt>echo $lastexitcode</tt>

or

   <tt>echo %errorlevel%</tt>

Zero (0) is the normal return code. So check for non-zero.

1 AWS S3 commands return if one or more S3 transfers failed.

2 AWS returns if it cannot parse the previous command due to missing required subcommands or arguments or unknown commands or arguments.

## Commands

https://github.com/swoodford/aws


## References

* <a target="_blank" href="https://docs.aws.amazon.com/cli/latest/index.html">AWS CLI Command Reference</a> which has at the bottom of the list <a target="_blank" href="https://docs.aws.amazon.com/cli/latest/topic/index.html">Topic Guide</a> 

https://docs.aws.amazon.com/cli/latest/topic/s3-config.html#cli-aws-help-s3-config

https://docs.aws.amazon.com/cli/latest/topic/s3-faq.html#cli-aws-help-s3-faq


## YouTube Videos about AWS CLI

* <a target="_blank" href="https://www.youtube.com/watch?v=ZbgvG7yFoQI">Deep Dive: AWS Command Line Interface [1:04:11] Apr 10, 2015</a> by Tom Jones, Amazon

* <a target="_blank" href="https://www.youtube.com/watch?v=hdIlcu75_Lw">Creating A Backup Script Using AWS CLI For Your Linux Machines</a> [17:34] Jun 23, 2016 by LinuxAcademy.com

* <a target="_blank" href="https://www.youtube.com/watch?v=aC7F_ntezVk">Introduction to AWS CLI ( AWS Command Line Tool)</a>
by Roham Sakhravi

* <a target="_blank" href="https://www.youtube.com/watch?v=WrVqrvIQRAI">Getting Started with AWS S3 CLI</a> by Melvin L

* <a target="_blank" href="https://www.youtube.com/watch?v=7z05U5ShhXg">Be a command line expert with aws cli - TOP 30 commands</a> by dython

* <a target="_blank" href="https://www.youtube.com/watch?v=qiPt1NoyZm0">Becoming a Command Line Expert with the AWS CLI (TLS304) at AWS re:Invent 2013</a>
