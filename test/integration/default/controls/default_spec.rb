# frozen_string_literal: true

title 'Default Suite Tests'

control 'confluence-install-01' do
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

control 'confluence-install-02' do
  impact 1.0
  title 'Confluence directories exist'
  desc 'The Confluence install and home directories should exist with correct permissions'

  describe directory('/opt/atlassian/confluence') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
  end

  describe directory('/var/atlassian/application-data/confluence') do
    it { should exist }
    its('mode') { should cmp '0750' }
    its('owner') { should eq 'confluence' }
    its('group') { should eq 'confluence' }
  end

  %w(logs temp work).each do |dir|
    describe directory("/opt/atlassian/confluence/#{dir}") do
      it { should exist }
      its('mode') { should cmp '0750' }
      its('owner') { should eq 'confluence' }
      its('group') { should eq 'confluence' }
    end
  end
end

control 'confluence-config-01' do
  impact 1.0
  title 'Confluence configuration files exist'
  desc 'Configuration files should exist with correct permissions'

  describe file('/opt/atlassian/confluence/confluence/WEB-INF/classes/confluence-init.properties') do
    it { should exist }
    its('mode') { should cmp '0640' }
    its('owner') { should eq 'root' }
    its('group') { should eq 'confluence' }
    its('content') { should match(%r{confluence\.home=/var/atlassian/application-data/confluence}) }
  end

  describe file('/opt/atlassian/confluence/bin/setenv.sh') do
    it { should exist }
    its('mode') { should cmp '0750' }
    its('owner') { should eq 'root' }
    its('group') { should eq 'confluence' }
    its('content') { should match(/-Xms512m/) }
    its('content') { should match(/-Xmx2g/) }
  end

  describe file('/opt/atlassian/confluence/conf/server.xml') do
    it { should exist }
    its('mode') { should cmp '0640' }
    its('owner') { should eq 'root' }
    its('group') { should eq 'confluence' }
    its('content') { should match(/port="8090"/) }
  end
end

control 'confluence-service-01' do
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
    its('content') { should match(%r{ExecStop=/opt/atlassian/confluence/bin/stop-confluence.sh}) }
    its('content') { should match(/User=confluence/) }
    its('content') { should match(/Group=confluence/) }
  end
end
