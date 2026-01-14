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

    it 'creates the systemd service unit' do
      expect(chef_run).to create_systemd_unit('confluence.service')
    end
  end

  context 'with :enable action' do
    recipe do
      confluence_service 'confluence' do
        action :enable
      end
    end

    it 'enables the confluence service' do
      expect(chef_run).to enable_systemd_unit('confluence.service')
    end
  end

  context 'with :start action' do
    recipe do
      confluence_service 'confluence' do
        action :start
      end
    end

    it 'starts the confluence service' do
      expect(chef_run).to start_systemd_unit('confluence.service')
    end
  end

  context 'with :stop action' do
    recipe do
      confluence_service 'confluence' do
        action :stop
      end
    end

    it 'stops the confluence service' do
      expect(chef_run).to stop_systemd_unit('confluence.service')
    end
  end

  context 'with :restart action' do
    recipe do
      confluence_service 'confluence' do
        action :restart
      end
    end

    it 'restarts the confluence service' do
      expect(chef_run).to restart_systemd_unit('confluence.service')
    end
  end

  context 'with :disable action' do
    recipe do
      confluence_service 'confluence' do
        action :disable
      end
    end

    it 'disables the confluence service' do
      expect(chef_run).to disable_systemd_unit('confluence.service')
    end
  end

  context 'with custom service name' do
    recipe do
      confluence_service 'production' do
        service_name 'confluence-prod'
        action :create
      end
    end

    it 'creates service with custom name' do
      expect(chef_run).to create_systemd_unit('confluence-prod.service')
    end
  end

  context 'with multiple actions' do
    recipe do
      confluence_service 'confluence' do
        action [:create, :enable]
      end
    end

    it 'creates the service unit' do
      expect(chef_run).to create_systemd_unit('confluence.service')
    end

    it 'enables the service' do
      expect(chef_run).to enable_systemd_unit('confluence.service')
    end
  end
end
