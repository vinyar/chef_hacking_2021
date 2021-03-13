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

# not needed. Matt embedded .net 5 into his installer
# windows_package 'Microsoft Windows Desktop Runtime - 5.0.4 (x64)' do
#   source 'https://download.visualstudio.microsoft.com/download/pr/7a5d15ae-0487-428d-8262-2824279ccc00/6a10ce9e632bce818ce6698d9e9faf39/windowsdesktop-runtime-5.0.4-win-x64.exe'
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

# windows_feature 'NET-Framework-Core' do                                                     # another way to get at it
# windows_feature_dism 'NET-Framework-Core' do                                                # another way to get at it
# windows_feature_powershell 'NET-Framework-Core' do
  # notifies :run, 'reboot[rebooting]', :immediately
  # guard_interpreter :powershell_script
  # not_if "(get-windowsfeature NET-Framework-Core).installed.tostring().tolower()"           # can't tell if this is working as intended
  # install_method :windows_feature_powershell                       # no idea where this came from or if this works
# end

# # package.zip gets plopped here: C:\Users\vagrant\AppData\Local\Temp\eyefinity\build-env
# # manual installation:  .\eyefinity.exe build-env install -p C:\Users\vagrant\AppData\Local\Temp\eyefinity\build-env\package.zip
powershell_script 'installing eyefinity dev tools' do
  code "#{download_location}/eyefinity_unzipped/eyefinity build-env install"
  # guard_interpreter :powershell_script
  # not_if 'Get-WmiObject -Class Win32_Product | where vendor -eq "Typemock Ltd"'                 # Doesn't seem to work.
  # not_if {reboot_pending?}
end
