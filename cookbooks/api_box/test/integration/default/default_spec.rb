
describe # https://inspec.io/docs/reference/resources/directory/
describe directory('c:\alex\was\here') do
  it { should exist }
end

describe directory('c:\bob') do
  it { should exist }
end

describe service('W3SVC') do
  it { should be_installed }
  it { should be_running }
  its('startmode') { should eq 'Auto' }
end

describe iis_site('Default Web Site') do
  it { should not_exist }
  it { should have_app_pool('DefaultAppPool') }
end
