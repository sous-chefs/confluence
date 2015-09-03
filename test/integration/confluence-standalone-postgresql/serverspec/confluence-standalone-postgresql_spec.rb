require 'spec_helper'

describe 'Java' do
  describe command('java -version 2>&1') do
    its(:exit_status) { should eq 0 }
  end
end

describe 'Postgresql' do
  describe port(5432) do
    it { should be_listening }
  end
end

describe 'Confluence' do
  describe port(8090) do
    it { should be_listening }
  end

  describe command("curl --noproxy localhost 'http://localhost:8090/setup/setupstart.action' | grep 'Set up Confluence'") do
    its(:exit_status) { should eq 0 }
  end
end

describe 'Apache2' do
  describe port(80) do
    it { should be_listening }
  end

  describe port(443) do
    it { should be_listening }
  end

  describe command("curl --insecure --noproxy localhost 'https://localhost/setup/setupstart.action' | grep 'Set up Confluence'") do
    its(:exit_status) { should eq 0 }
  end
end
