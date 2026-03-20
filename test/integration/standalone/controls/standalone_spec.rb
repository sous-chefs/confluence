# frozen_string_literal: true

title 'Standalone Suite Tests'

control 'confluence-standalone-install-01' do
  impact 1.0
  title 'Confluence user and group exist'
  desc 'The confluence system user and group should exist'

  describe user('confluence') do
    it { should exist }
    its('group') { should eq 'confluence' }
  end

  describe group('confluence') do
    it { should exist }
  end
end

control 'confluence-standalone-install-02' do
  impact 1.0
  title 'Confluence directories exist with default paths'
  desc 'The Confluence install and home directories should exist'

  describe directory('/opt/atlassian/confluence') do
    it { should exist }
  end

  describe directory('/var/atlassian/application-data/confluence') do
    it { should exist }
    its('mode') { should cmp '0750' }
    its('owner') { should eq 'confluence' }
    its('group') { should eq 'confluence' }
  end
end

control 'confluence-standalone-config-01' do
  impact 1.0
  title 'Confluence reverse proxy configuration'
  desc 'Configuration files should reflect reverse proxy settings'

  describe file('/opt/atlassian/confluence/bin/setenv.sh') do
    it { should exist }
    its('content') { should match(/-Xms1g/) }
    its('content') { should match(/-Xmx4g/) }
  end

  describe file('/opt/atlassian/confluence/conf/server.xml') do
    it { should exist }
    its('content') { should match(/port="8090"/) }
    its('content') { should match(/proxyName="confluence.example.com"/) }
    its('content') { should match(/proxyPort="443"/) }
    its('content') { should match(/scheme="https"/) }
    its('content') { should match(/secure="true"/) }
  end
end

control 'confluence-standalone-service-01' do
  impact 1.0
  title 'Confluence systemd service exists'
  desc 'The Confluence systemd service unit should be installed and enabled'

  describe systemd_service('confluence') do
    it { should be_installed }
    it { should be_enabled }
  end

  describe file('/etc/systemd/system/confluence.service') do
    it { should exist }
    its('content') { should match(/Type=forking/) }
    its('content') { should match(%r{ExecStart=/opt/atlassian/confluence/bin/start-confluence.sh}) }
  end
end
