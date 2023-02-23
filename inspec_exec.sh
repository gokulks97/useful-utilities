#!/bin/bash

#USAGE:
#1) Place this file inside a common folder
#2) Update the profile path
#3) Update the ssh username, ip and pem file and save the file
#4) Check the necessary permission for execution.
#5) run like 
# $./inspec_exec.sh "xccdf_org.cisecurity.benchmarks_rule_2.2.18_Ensure_rpcbind_is_not_installed_or_the__rpcbind_services_are_masked"
#6) now going forward once new control needs to be ran
# 6.1) type ./ins and then clikc <tab> and copy paste the control id/title with double quotes..

# the control id from terminal will be available in $1
# inspec exec ../<path-to-profile> -t ssh://<user-name>@<ip-address> -i ~/<path/file_name>.pem --controls $1 --sudo
inspec exec ../src/inspec/supported/cis-oraclelinux7-level2-server-v3.1.1 -t ssh://pc2-u5er@255.255.255.255 -i ~/Downloads/sample.pem --controls $1 --sudo
