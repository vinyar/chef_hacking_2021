
describe # https://inspec.io/docs/reference/resources/directory/
describe directory('c:\alex\was\here') do
  it { should exist }
end

describe directory('c:\bob') do
  it { should exist }
end



# describe service('W3SVC') do
#   it { should be_installed }
#   it { should be_running }
#   its('startmode') { should eq 'Auto' }
# end
#
# # Unless we are on a 'polluted' machine, the default website should
# # be present if the IIS Role was freshly installed. All our vagrant
# # configurations install with the system drive at C:\
# describe iis_site('Default Web Site') do
#   it { should exist }
#   it { should be_running }
#   it { should have_app_pool('DefaultAppPool') }
# end
