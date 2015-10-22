require 'serverspec'

set :backend, :exec

shared_examples_for 'confluence behind the apache proxy' do
  describe 'Tomcat' do
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
end
