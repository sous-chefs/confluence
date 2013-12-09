require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'confluence::linux_standalone' do
  include Helpers::Confluence

  it 'has confluence user' do
    user(node['confluence']['user']).must_exist.with(:home, node['confluence']['home_path'])
  end

  it 'starts Confluence' do
    service('confluence').must_be_running
  end

  it 'enables Confluence' do
    service('confluence').must_be_enabled
  end

end
