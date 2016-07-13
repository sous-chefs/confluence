require 'spec_helper'

describe 'confluence::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['confluence']['install_path'] = '/opt/atlassian/confluence'
      node.set['confluence']['home_path'] = '/var/atlassian/application-data/confluence'
      node.set['mysql']['server_root_password'] = 'foo'
    end.converge(described_recipe)
  end

  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
  end

  it 'renders server.xml' do
    path = '/opt/atlassian/confluence/conf/server.xml'
    resource = chef_run.template(path)

    expect(resource).to notify('service[confluence]').to(:restart)
    expect(chef_run).to render_file(path)
  end

  context 'for "installer" installation type' do
    it 'uses the bundled JRE' do
      expect(chef_run).to render_file('/opt/atlassian/confluence/bin/setenv.sh')
        .with_content { |content|
          expect(content).to include('JRE_HOME="/opt/atlassian/confluence/jre/"')
        }
    end
  end

  context 'for "installer" installation type' do
    it 'uses JRE managed by "java" cookbook when bundled_jre attribute is false' do
      chef_run.node.set['java']['java_home'] = '/usr/lib/jvm/java'
      chef_run.node.set['confluence']['jvm']['bundled_jre'] = false

      expect(chef_run).to render_file('/opt/atlassian/confluence/bin/setenv.sh')
        .with_content { |content|
          expect(content).to include('JRE_HOME="/usr/lib/jvm/java/jre/"')
        }
    end
  end

  context 'for "standalone" installation type' do
    it 'uses JRE managed by "java" cookbook' do
      chef_run.node.set['java']['java_home'] = '/usr/lib/jvm/java'
      chef_run.node.set['confluence']['install_type'] = 'standalone'

      expect(chef_run).to render_file('/opt/atlassian/confluence/bin/setenv.sh')
        .with_content { |content|
          expect(content).to include('JRE_HOME="/usr/lib/jvm/java/jre/"')
        }
    end
  end
end
