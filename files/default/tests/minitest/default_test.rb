require File.expand_path('../support/helpers', __FILE__)

describe_recipe "confluence::default" do
  include Helpers::Confluence

  it 'has confluence run_user' do
  	user(node['confluence']['user']).must_exist.with(:home, node['confluence']['home_path'])
  end

  it 'creates Java KeyStore' do
  	file("#{node['confluence']['home_path']}/.keystore").must_exist.with(:owner, node['confluence']['user'])
  end

  it 'creates Confluence properties file' do
  	file("#{node['confluence']['install_path']}/confluence-config.properties").must_exist
  end

  it 'starts Confluence' do
    service("confluence").must_be_running
  end

  it 'enables Confluence' do
    service("confluence").must_be_enabled
  end
  
end
