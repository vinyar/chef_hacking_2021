#
# Cookbook:: api_box
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

directory 'c:\alex\was\here' do
  recursive true
  action :create
end

directory 'c:\bob'
