require 'spec_helper'

describe 'confluence_config' do
  platform 'ubuntu', '24.04'

  step_into :confluence_config

  context 'with default properties' do
    recipe do
      confluence_config 'confluence'
    end

    it 'creates confluence-init.properties' do
      expect(chef_run).to create_template('/opt/atlassian/confluence/confluence/WEB-INF/classes/confluence-init.properties').with(
        source: 'confluence-init.properties.erb',
        cookbook: 'confluence',
        owner: 'root',
        group: 'confluence',
        mode: '0640'
      )
    end

    it 'creates setenv.sh' do
      expect(chef_run).to create_template('/opt/atlassian/confluence/bin/setenv.sh').with(
        source: 'setenv.sh.erb',
        cookbook: 'confluence',
        owner: 'root',
        group: 'confluence',
        mode: '0750'
      )
    end

    it 'creates server.xml' do
      expect(chef_run).to create_template('/opt/atlassian/confluence/conf/server.xml').with(
        source: 'server.xml.erb',
        cookbook: 'confluence',
        owner: 'root',
        group: 'confluence',
        mode: '0640'
      )
    end
  end

  context 'with custom JVM settings' do
    recipe do
      confluence_config 'confluence' do
        jvm_minimum_memory '1g'
        jvm_maximum_memory '4g'
      end
    end

    it 'passes JVM settings to setenv.sh template' do
      expect(chef_run).to create_template('/opt/atlassian/confluence/bin/setenv.sh')
      template = chef_run.template('/opt/atlassian/confluence/bin/setenv.sh')
      expect(template.variables[:jvm_minimum_memory]).to eq('1g')
      expect(template.variables[:jvm_maximum_memory]).to eq('4g')
    end
  end

  context 'with reverse proxy configuration' do
    recipe do
      confluence_config 'confluence' do
        tomcat_proxy_name 'confluence.example.com'
        tomcat_proxy_port '443'
        tomcat_scheme 'https'
        tomcat_secure true
      end
    end

    it 'passes proxy settings to server.xml template' do
      expect(chef_run).to create_template('/opt/atlassian/confluence/conf/server.xml')
      template = chef_run.template('/opt/atlassian/confluence/conf/server.xml')
      expect(template.variables[:tomcat_proxy_name]).to eq('confluence.example.com')
      expect(template.variables[:tomcat_proxy_port]).to eq('443')
      expect(template.variables[:tomcat_scheme]).to eq('https')
      expect(template.variables[:tomcat_secure]).to eq(true)
    end
  end

  context 'with custom paths' do
    recipe do
      confluence_config 'confluence' do
        install_path '/opt/confluence'
        home_path '/data/confluence'
        user 'atlassian'
        group 'atlassian'
      end
    end

    it 'creates templates in custom install path' do
      expect(chef_run).to create_template('/opt/confluence/confluence/WEB-INF/classes/confluence-init.properties')
      expect(chef_run).to create_template('/opt/confluence/bin/setenv.sh')
      expect(chef_run).to create_template('/opt/confluence/conf/server.xml')
    end

    it 'uses custom group for file permissions' do
      expect(chef_run).to create_template('/opt/confluence/bin/setenv.sh').with(
        group: 'atlassian'
      )
    end

    it 'passes custom home_path to templates' do
      template = chef_run.template('/opt/confluence/confluence/WEB-INF/classes/confluence-init.properties')
      expect(template.variables[:home_path]).to eq('/data/confluence')
    end
  end

  context 'with custom template cookbook' do
    recipe do
      confluence_config 'confluence' do
        template_cookbook 'my_wrapper'
      end
    end

    it 'sources templates from custom cookbook' do
      expect(chef_run).to create_template('/opt/atlassian/confluence/confluence/WEB-INF/classes/confluence-init.properties').with(
        cookbook: 'my_wrapper'
      )
    end
  end
end
