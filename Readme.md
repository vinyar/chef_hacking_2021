# Purpose

A hacking repo to serve as a base for recreating a production server locally.

Primary focus is on post deployment validation with inspec.


# Get started
install virtualbox from oracle  
install chef-workstation from chef.io  
install vagrant from hashicorp.com (you dont have to reboot)  
Open new command prompt  
validate ` vagrant ` runs  
validate ` kitchen ` runs  
clone this repo  
go to .\cookbooks\api_box  
run `kitchen test --destroy always`


# Expected result
kitchen downloads 5.5 gb Windows 2016 file  
stands up a vm in virtual box  
runs a simple chef recipe (defined in kitchen.yml)  
runs integration tests with InSpec against the VM  
deletes the box  

# Hack away
Thanks
