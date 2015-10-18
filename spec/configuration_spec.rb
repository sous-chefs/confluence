require 'spec_helper'

describe 'confluence::configuration' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['confluence']['install_path'] = '/opt/atlassian/confluence'
      node.set['confluence']['home_path'] = '/var/atlassian/application-data/confluence'
    end.converge(described_recipe)
  end

  it 'renders confluence-init.properties' do
    expect(chef_run).to render_file('/opt/atlassian/confluence/confluence/WEB-INF/classes/confluence-init.properties')
      .with_content { |content|
        expect(content).to include('confluence.home=/var/atlassian/application-data/confluence')
      }
  end

  it 'enables Confluence service' do
    expect(chef_run).to enable_service('confluence')
  end
end
