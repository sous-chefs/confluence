require 'serverspec'
require 'infrataster/rspec'

set :backend, :exec

Infrataster::Server.define(:confluence_web, '127.0.0.1')

shared_examples_for 'confluence behind the apache proxy' do
  describe 'Tomcat' do
    describe port(8090) do
      it { should be_listening }
    end
  end

  describe 'Apache2' do
    describe port(80) do
      it { should be_listening }
    end

    describe port(443) do
      it { should be_listening }
    end
  end

  describe server(:confluence_web) do
    describe http('http://127.0.0.1/setup/setupstart.action') do
      it 'redirects 80 port to 443' do
        expect(response.status).to eq(302)
        expect(response.headers['location']).to eq('https://127.0.0.1/setup/setupstart.action')
      end
    end

    describe http('https://127.0.0.1/setup/setupstart.action', ssl: { verify: false }) do
      it 'returns setup wizard' do
        expect(response.status).to eq(200)
        expect(response.body).to include('Set up Confluence')
      end
    end

    describe http('http://127.0.0.1:8090/setup/setupstart.action') do
      it 'returns setup wizard' do
        expect(response.status).to eq(200)
        expect(response.body).to include('Set up Confluence')
      end
    end
  end
end
