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

windows_package 'Microsoft Windows Desktop Runtime - 5.0.4 (x64)' do
  source 'https://download.visualstudio.microsoft.com/download/pr/7a5d15ae-0487-428d-8262-2824279ccc00/6a10ce9e632bce818ce6698d9e9faf39/windowsdesktop-runtime-5.0.4-win-x64.exe'
  # source "#{download_location}/windowsdesktop-runtime-5.0.4-win-x64.exe"
  # checksum '69fcbe5458869246cbd0657764ec3fdbfd59f06a49808cb283a7c90271409b0266539d31cec9047c512f167cae8e2992b617b68bc9f93e4815a37a8f50524d3f'
  installer_type :custom
  options '/quiet'
  action :install
  not_if {reboot_pending?}
end


remote_file "#{download_location}/eyefinity.exe" do
  source 'http://artifactory.vsp.com/eyefinity-devtool/cli/eyefinity/eyefinity-1.0.1.exe'
  action :create
  not_if {reboot_pending?}
end

# package.zip gets plopped here: C:\Users\vagrant\AppData\Local\Temp\eyefinity\build-env
# manual installation:  .\eyefinity.exe build-env install -p C:\Users\vagrant\AppData\Local\Temp\eyefinity\build-env\package.zip
execute 'installing eyefinity dev tools' do
  command "#{download_location}/eyefinity build-env install"
  action :run
end
