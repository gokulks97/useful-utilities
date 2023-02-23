#

# inspec exec ../src/inspec/[un]supported/<profile-name> -t ssh://<user-name>@<ip-address> -i ~/<path/file_name>.pem --controls $1 --sudo

inspec exec ../src/inspec/supported/cis-oraclelinux7-level2-server-v3.1.1 -t ssh://pc2-u5er@255.255.255.255 -i ~/Downloads/sample.pem --controls $1 --sudo
