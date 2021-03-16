#
# Cookbook:: api_box
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

directory 'making a mark' do
  path 'c:\alex\was\here'
  recursive true
  action :create
end

directory 'c:\bob'
# execute 'also created folder, but harder' do
#   command 'powershell -command  "& {mkdir -Path c:\bob -Force}"'
#   action :run
#   # not_if {}
# end

windows_feature_powershell 'installing file services' do
  feature_name 'RSAT-File-Services'
  all false
  # source 'localrepository'
  action :install
end

# Using community IIS cookbook to install and configure IIS

# This really lives in attributes, but showing here for simplicity.
node.default['api_box']['windows_features'] = %w(Web-Http-Errors IIS-NetFxExtensibility IIS-ASPNET)

include_recipe 'iis::default'

# adding .net 45 support via community IIS cookbook
include_recipe 'iis::mod_ftp'

# adding management tools via community IIS cookbook
include_recipe 'iis::mod_management'

# remove default site
include_recipe 'iis::remove_default_site'

# using community IIS cookbook to make some new sites
iis_site 'alex-was-here' do
  port 4321
  path 'c:\alex\was\here'
  protocol :ftp
  host_header 'i_like_cupcakes'
  running true
end

node.default['api_box']['dev_mode'] = 'true'

iis_section 'unlocks anonymous authentication control in web.config' do
  site 'alex-was-here'
  section 'system.webServer/security/authentication/anonymousAuthentication'
  action :unlock
  only_if { node['api_box']['dev_mode'] }
end

reboot 'reboot if pending' do
  reason 'Need to reboot when the run completes successfully.'
  delay_mins 0
  action :request_reboot
  only_if { reboot_pending? }
end
