# Documentation:
#     https://confluence.vspglobal.com/display/devland/Infrastructure+CLI
#     https://confluence.vspglobal.com/display/devland/Eyefinity+CLI


# on windows this is C:\Users\vagrant\AppData\Local\Temp\kitchen\cache
download_location = "#{Chef::Config['file_cache_path']}"

# remote_file "#{download_location}/windowsdesktop-runtime-5.0.4-win-x64.exe" do
#   source 'https://download.visualstudio.microsoft.com/download/pr/7a5d15ae-0487-428d-8262-2824279ccc00/6a10ce9e632bce818ce6698d9e9faf39/windowsdesktop-runtime-5.0.4-win-x64.exe'
#   action :create
# end

# have to address this:
# curl : The response content cannot be parsed because the Internet Explorer engine is not available, or Internet Explorer's
# first-launch configuration is not complete. Specify the UseBasicParsing parameter and try again.

# windows_package 'Microsoft Windows Desktop Runtime - 5.0.4 (x64)' do
#   source 'https://download.visualstudio.microsoft.com/download/pr/7a5d15ae-0487-428d-8262-2824279ccc00/6a10ce9e632bce818ce6698d9e9faf39/windowsdesktop-runtime-5.0.4-win-x64.exe'
#   # source "#{download_location}/windowsdesktop-runtime-5.0.4-win-x64.exe"
#   # checksum '69fcbe5458869246cbd0657764ec3fdbfd59f06a49808cb283a7c90271409b0266539d31cec9047c512f167cae8e2992b617b68bc9f93e4815a37a8f50524d3f'
#   installer_type :custom
#   options '/quiet'
#   action :install
#   not_if {reboot_pending?}
# end


remote_file "#{download_location}/eyefinity.zip" do
  # source 'http://artifactory.vsp.com/eyefinity-devtool/cli/eyefinity/eyefinity-1.0.1.exe'  # version w/o .net 5
  source 'http://artifactory.vsp.com/eyefinity-devtool/cli/eyefinity/eyefinity-1.1.0-beta.zip'
  action :create
end

directory "#{download_location}/eyefinity_unzipped"

archive_file "#{download_location}/eyefinity.zip" do
  destination "#{download_location}/eyefinity_unzipped"
  overwrite true
  not_if { ::File.exist?("#{download_location}/eyefinity_unzipped/eyefinity.exe") }
end

# windows_feature '.NET Framework 3.5'
# windows_feature_dism '.NET Framework 3.5'
windows_feature_powershell 'NET-Framework-Core' do
  notifies :run, 'reboot[rebooting]', :immediately
  guard_interpreter :powershell
  not_if {(get-windowsfeature NET-Framework-Core).installed}
end

reboot 'rebooting' do
  action :nothing
end

# windows_feature '.NET Framework 3.5' do
#   feature_name          Array, String # default value: 'name' unless specified
#   install_method        Symbol # default value: :windows_feature_dism
#   management_tools      true, false # default value: false
#   source                String
#   timeout               Integer # default value: 600
#   action                Symbol # defaults to :install if not specified
# end

# # package.zip gets plopped here: C:\Users\vagrant\AppData\Local\Temp\eyefinity\build-env
# # manual installation:  .\eyefinity.exe build-env install -p C:\Users\vagrant\AppData\Local\Temp\eyefinity\build-env\package.zip
execute 'installing eyefinity dev tools' do
  command "#{download_location}/eyefinity_unzipped/eyefinity build-env install"
  action :run
  guard_interpreter :powershell
  not_if { Get-WmiObject -Class Win32_Product | where vendor -eq 'Typemock Ltd' }
end
