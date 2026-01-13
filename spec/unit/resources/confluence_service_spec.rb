require 'spec_helper'

describe 'confluence_service' do
  platform 'ubuntu', '24.04'

  step_into :confluence_service

  context 'with :create action' do
    recipe do
      confluence_service 'confluence' do
        action :create
      end
    end

    it 'creates the systemd service unit file' do
      expect(chef_run).to create_template('/etc/systemd/system/confluence.service').with(
        source: 'confluence.service.erb',
        cookbook: 'confluence',
        owner: 'root',
        group: 'root',
        mode: '0644'
      )
    end

    it 'passes correct variables to the template' do
      template = chef_run.template('/etc/systemd/system/confluence.service')
      expect(template.variables[:user]).to eq('confluence')
      expect(template.variables[:group]).to eq('confluence')
      expect(template.variables[:install_path]).to eq('/opt/atlassian/confluence')
      expect(template.variables[:home_path]).to eq('/var/atlassian/application-data/confluence')
    end

    it 'notifies systemctl daemon-reload' do
      template = chef_run.template('/etc/systemd/system/confluence.service')
      expect(template).to notify('execute[systemctl-daemon-reload]').to(:run).immediately
    end
  end

  context 'with :enable action' do
    recipe do
      confluence_service 'confluence' do
        action :enable
      end
    end

    it 'enables the confluence service' do
      expect(chef_run).to enable_service('confluence')
    end
  end

  context 'with :start action' do
    recipe do
      confluence_service 'confluence' do
        action :start
      end
    end

    it 'starts the confluence service' do
      expect(chef_run).to start_service('confluence')
    end
  end

  context 'with :stop action' do
    recipe do
      confluence_service 'confluence' do
        action :stop
      end
    end

    it 'stops the confluence service' do
      expect(chef_run).to stop_service('confluence')
    end
  end

  context 'with :restart action' do
    recipe do
      confluence_service 'confluence' do
        action :restart
      end
    end

    it 'restarts the confluence service' do
      expect(chef_run).to restart_service('confluence')
    end
  end

  context 'with :disable action' do
    recipe do
      confluence_service 'confluence' do
        action :disable
      end
    end

    it 'disables the confluence service' do
      expect(chef_run).to disable_service('confluence')
    end
  end

  context 'with custom properties' do
    recipe do
      confluence_service 'production' do
        service_name 'confluence-prod'
        install_path '/opt/confluence-prod'
        home_path '/data/confluence-prod'
        user 'atlassian'
        group 'atlassian'
        action :create
      end
    end

    it 'creates service with custom name' do
      expect(chef_run).to create_template('/etc/systemd/system/confluence-prod.service')
    end

    it 'passes custom variables to template' do
      template = chef_run.template('/etc/systemd/system/confluence-prod.service')
      expect(template.variables[:user]).to eq('atlassian')
      expect(template.variables[:group]).to eq('atlassian')
      expect(template.variables[:install_path]).to eq('/opt/confluence-prod')
      expect(template.variables[:home_path]).to eq('/data/confluence-prod')
    end
  end

  context 'with multiple actions' do
    recipe do
      confluence_service 'confluence' do
        action [:create, :enable]
      end
    end

    it 'creates the service unit file' do
      expect(chef_run).to create_template('/etc/systemd/system/confluence.service')
    end

    it 'enables the service' do
      expect(chef_run).to enable_service('confluence')
    end
  end
end
