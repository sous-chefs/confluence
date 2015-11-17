require 'spec_helper'

describe 'confluence::database' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['confluence']['data_bag_name'] = 'apps'
      node.set['confluence']['data_bag_item'] = 'test_confluence'
      node.set['confluence']['database']['name'] = 'test_database'
      node.set['confluence']['database']['user'] = 'foo'
      node.set['confluence']['database']['password'] = 'bar'
      node.set['mysql']['server_root_password'] = 'mysql_root_pass'
      node.set['postgresql']['password']['postgres'] = 'postgres_pass'
    end.converge(described_recipe)
  end

  context 'When data bag does not exit' do
    before do
      chef_run.node.set['confluence']['database']['type'] = 'mysql'
    end

    let(:connection) do
      {
        host: '127.0.0.1',
        port: 3306,
        username: 'root',
        password: 'mysql_root_pass'
      }
    end

    it 'sets up MySQL service' do
      expect(chef_run).to create_mysql_service('confluence').with(
        bind_address: '127.0.0.1',
        port: '3306',
        initial_root_password: 'mysql_root_pass'
      )
    end

    it 'creates MySQL database' do
      expect(chef_run).to create_mysql_database('test_database').with(
        collation: 'utf8_bin',
        encoding: 'utf8',
        connection: connection
      )
    end

    it 'creates MySQL user' do
      expect(chef_run).to create_mysql_database_user('foo').with(
        host: '%',
        password: 'bar',
        database_name: 'test_database',
        connection: connection
      )
    end
  end

  context 'When data bag exists' do
    before do
      data_bag = {
        'id' => 'test_confluence',
        'confluence' => {
          'database' => {
            'type' => 'postgresql',
            'user' => 'db_user',
            'password' => 'db_password'
          }
        }
      }
      stub_data_bag('apps').and_return(['test_confluence'])
      stub_data_bag_item('apps', 'test_confluence').and_return(data_bag)
      # Required for "postgresql::server" converge
      stub_command(%r{ls \/.*\/recovery.conf}).and_return(false)
    end

    let(:connection) do
      {
        host: '127.0.0.1',
        port: 5432,
        username: 'postgres',
        password: 'postgres_pass'
      }
    end

    it 'sets up PostgreSQL service' do
      expect(chef_run).to include_recipe('postgresql::server')
      expect(chef_run).to include_recipe('database::postgresql')
    end

    it 'creates PostgreSQL user' do
      expect(chef_run).to create_postgresql_database_user('db_user').with(
        password: 'db_password',
        connection: connection
      )
    end

    it 'creates PostgeSQL database' do
      expect(chef_run).to create_postgresql_database('test_database').with(
        encoding: 'utf8',
        owner: 'db_user',
        connection: connection
      )
    end
  end
end
