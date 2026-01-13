require 'spec_helper'

describe 'confluence_install' do
  platform 'ubuntu', '24.04'

  step_into :confluence_install

  context 'with default properties' do
    recipe do
      confluence_install 'confluence' do
        version '10.2.2'
      end
    end

    it 'creates the confluence group' do
      expect(chef_run).to create_group('confluence').with(system: true)
    end

    it 'creates the confluence user' do
      expect(chef_run).to create_user('confluence').with(
        comment: 'Confluence Service Account',
        home: '/var/atlassian/application-data/confluence',
        shell: '/usr/sbin/nologin',
        gid: 'confluence',
        system: true
      )
    end

    it 'creates the home directory parent' do
      expect(chef_run).to create_directory('/var/atlassian/application-data').with(
        owner: 'root',
        group: 'root',
        mode: '0755',
        recursive: true
      )
    end

    it 'creates the home directory' do
      expect(chef_run).to create_directory('/var/atlassian/application-data/confluence').with(
        owner: 'confluence',
        group: 'confluence',
        mode: '0750',
        recursive: true
      )
    end

    it 'creates the install directory parent' do
      expect(chef_run).to create_directory('/opt/atlassian').with(
        owner: 'root',
        group: 'root',
        mode: '0755',
        recursive: true
      )
    end

    it 'downloads the confluence tarball' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/confluence-10.2.2.tar.gz").with(
        source: 'https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-10.2.2.tar.gz',
        owner: 'root',
        group: 'root',
        mode: '0644'
      )
    end

    it 'extracts the confluence tarball' do
      expect(chef_run).to extract_archive_file("#{Chef::Config[:file_cache_path]}/confluence-10.2.2.tar.gz").with(
        destination: '/opt/atlassian/confluence',
        strip_components: 1
      )
    end

    %w(logs temp work).each do |dir|
      it "creates the #{dir} directory with correct ownership" do
        expect(chef_run).to create_directory("/opt/atlassian/confluence/#{dir}").with(
          owner: 'confluence',
          group: 'confluence',
          mode: '0750'
        )
      end
    end
  end

  context 'with custom properties' do
    recipe do
      confluence_install 'confluence' do
        version '10.2.2'
        install_path '/opt/confluence'
        home_path '/data/confluence'
        user 'atlassian'
        group 'atlassian'
      end
    end

    it 'creates the custom group' do
      expect(chef_run).to create_group('atlassian').with(system: true)
    end

    it 'creates the custom user' do
      expect(chef_run).to create_user('atlassian').with(
        home: '/data/confluence',
        gid: 'atlassian'
      )
    end

    it 'creates the custom home directory' do
      expect(chef_run).to create_directory('/data/confluence').with(
        owner: 'atlassian',
        group: 'atlassian'
      )
    end

    it 'extracts to custom install path' do
      expect(chef_run).to extract_archive_file("#{Chef::Config[:file_cache_path]}/confluence-10.2.2.tar.gz").with(
        destination: '/opt/confluence'
      )
    end
  end

  context 'with custom URL and checksum' do
    recipe do
      confluence_install 'confluence' do
        version '10.2.2'
        url 'https://mirror.example.com/confluence-10.2.2.tar.gz'
        checksum 'a' * 64
      end
    end

    it 'uses the custom URL' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/confluence-10.2.2.tar.gz").with(
        source: 'https://mirror.example.com/confluence-10.2.2.tar.gz',
        checksum: 'a' * 64
      )
    end
  end
end
