

describe # https://inspec.io/docs/reference/resources/directory/
describe directory('c:\alex\was\here') do
  it { should exist }
end

describe directory('c:\bob') do
  it { should exist }
end

# TODO: validate tools

describe service('W3SVC') do
  it { should be_installed }
  it { should be_running }
  its('startmode') { should eq 'Auto' }
end

describe service('FTPSVC') do
  it { should be_installed }
  it { should be_running }
  its('startmode') { should eq 'Auto' }
end

describe iis_site('Default Web Site') do
  it { should_not exist }
  it { should_not have_app_pool('DefaultAppPool') }
end

describe iis_site('alex-was-here') do
  it { should exist }
  it { should be_running }
  it { should_not have_app_pool('DefaultAppPool') }
  its('bindings') { should eq ['ftp *:4321:i_like_cupcakes'] }
end


describe powershell("(Get-WebConfigurationProperty -PSPath \"MACHINE/WEBROOT/APPHOST\" \
                    -filter \"system.applicationHost/sites/siteDefaults/logfile\" \
                    -Name \"directory\").value") do
  its('stdout') { should eq "%SystemDrive%\\inetpub\\logs\\LogFiles\r\n" }
end

# doesn't work for some reason.
# describe iis_section('system.webServer/security/authentication/anonymousAuthentication', 'alex-was-here') do
#   it { should exist }
#   it { should have_has_locked('unlocked') }
#   it { should have_override_mode('Allow') }
#   it { should have_override_mode_effective('Allow') }
# end



# Group your tests by controls
control 'sample group tmp-1.0' do           # A unique ID for this control
  impact 0.7                                # The criticality, if this control fails.
  title 'A human-readable title...'
  desc 'An optional description...'

  describe directory('c:\chef') do
    it { should exist }
  end

  describe user('vagrant') do
    it { should exist }
  end

end
