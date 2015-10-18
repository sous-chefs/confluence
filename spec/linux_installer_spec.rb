require 'spec_helper'

describe 'confluence::linux_installer' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['confluence']['version'] = '5.7.1'
      node.set['confluence']['install_path'] = '/opt/atlassian/confluence'
      node.automatic['kernel']['machine'] = 'x86_64'
    end.converge(described_recipe)
  end

  context 'When Confluence is not installed' do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:confluence_version).and_return(nil)
    end

    it 'renders a response file for clean installation' do
      expect(chef_run).to render_file('/var/cache/chef/atlassian-confluence-response.varfile')
        .with_content { |content|
          expect(content).to include('sys.confirmedUpdateInstallationString=false')
        }
    end

    it 'downloads the installer' do
      expect(chef_run).to create_remote_file('/var/cache/chef/atlassian-confluence-5.7.1.bin')
        .with(
          source: 'http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.7.1-x64.bin',
          checksum: '6144b112913d3114caaac93f5ee43191d22980ca704f3b53ef7725dff306d1ee'
        )
    end

    it 'installs Confluence' do
      expect(chef_run).to run_execute('Installing Confluence 5.7.1')
        .with(command: './atlassian-confluence-5.7.1.bin -q -varfile atlassian-confluence-response.varfile')
    end
  end

  context 'When other Confluence version is installed' do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:confluence_version).and_return('5.6.5')
    end

    it 'renders a response file for update' do
      allow(Dir).to receive(:exist?).with('/opt/atlassian/confluence').and_return(true)

      expect(chef_run).to render_file('/var/cache/chef/atlassian-confluence-response.varfile')
        .with_content { |content|
          expect(content).to include('sys.confirmedUpdateInstallationString=true')
        }
    end

    it 'downloads the installer' do
      expect(chef_run).to create_remote_file('/var/cache/chef/atlassian-confluence-5.7.1.bin')
        .with(
          source: 'http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.7.1-x64.bin',
          checksum: '6144b112913d3114caaac93f5ee43191d22980ca704f3b53ef7725dff306d1ee'
        )
    end

    it 'Updates Confluence to the newer version' do
      expect(chef_run).to run_execute('Installing Confluence 5.7.1')
        .with(command: './atlassian-confluence-5.7.1.bin -q -varfile atlassian-confluence-response.varfile')
    end
  end

  context 'When the appropriate Confluence version is already installed' do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:confluence_version).and_return('5.7.1')
    end

    it 'does not run the installer' do
      expect(chef_run).not_to run_execute('Installing Confluence 5.7.1')
    end
  end
end
