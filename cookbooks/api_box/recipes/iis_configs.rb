iis_section 'unlocks windows authentication control in web.config' do
  site 'alex-was-here'
  section 'system.webServer/security/authentication/windowsAuthentication'
  action :unlock
end
