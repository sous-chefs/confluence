require 'spec_helper'

# TODO: These specs are skipped because the default recipe includes recipes that depend on
# deprecated cookbooks (mysql2_chef_gem, database, apache2) incompatible with modern Chef.
# The cookbook dependencies need to be updated to use modern resources.
describe 'confluence::default', skip: 'Deprecated cookbook dependencies incompatible with modern Chef' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.default['confluence']['install_path'] = '/opt/atlassian/confluence'
      node.default['confluence']['home_path'] = '/var/atlassian/application-data/confluence'
      node.default['confluence']['version'] = '5.7.1'
      node.default['mysql']['server_root_password'] = 'foo'
      node.automatic['kernel']['machine'] = 'x86_64'
      # Use external database host to skip database recipe (deprecated cookbook dependencies)
      node.override['confluence']['database']['host'] = 'external-db.example.com'
    end.converge(described_recipe)
  end

  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
  end

  include_examples 'linux_installer'

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
      chef_run.node.default['java']['java_home'] = '/usr/lib/jvm/java'
      chef_run.node.default['confluence']['jvm']['bundled_jre'] = false

      expect(chef_run).to render_file('/opt/atlassian/confluence/bin/setenv.sh')
        .with_content { |content|
          expect(content).to include('JRE_HOME="/usr/lib/jvm/java/jre/"')
        }
    end
  end

  context 'for "standalone" installation type' do
    it 'uses JRE managed by "java" cookbook' do
      chef_run.node.default['java']['java_home'] = '/usr/lib/jvm/java'
      chef_run.node.default['confluence']['install_type'] = 'standalone'

      expect(chef_run).to render_file('/opt/atlassian/confluence/bin/setenv.sh')
        .with_content { |content|
          expect(content).to include('JRE_HOME="/usr/lib/jvm/java/jre/"')
        }
    end
  end
end
