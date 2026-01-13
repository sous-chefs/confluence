require 'spec_helper'

describe 'confluence_install' do
  platform 'ubuntu', '24.04'

  step_into :confluence_install

  context 'with default properties' do
    recipe do
      confluence_install 'confluence' do
        version '8.5.4'
      end
    end

    it 'creates the confluence group' do
      expect(chef_run).to create_group('confluence').with(system: true)
    end

    it 'creates the confluence user' do
      expect(chef_run).to create_user('confluence').with(
        comment: 'Confluence Service Account',
        home: '/var/atlassian/application-data/confluence',
        shell: '/bin/bash',
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

    it 'downloads and extracts confluence using ark' do
      expect(chef_run).to install_ark('confluence').with(
        url: 'https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-8.5.4.tar.gz',
        prefix_root: '/opt/atlassian',
        home_dir: '/opt/atlassian/confluence',
        version: '8.5.4',
        owner: 'root',
        group: 'root'
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
        version '8.5.4'
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
      expect(chef_run).to install_ark('confluence').with(
        prefix_root: '/opt',
        home_dir: '/opt/confluence'
      )
    end
  end

  context 'with custom URL and checksum' do
    recipe do
      confluence_install 'confluence' do
        version '8.5.4'
        url 'https://mirror.example.com/confluence-8.5.4.tar.gz'
        checksum 'a' * 64
      end
    end

    it 'uses the custom URL' do
      expect(chef_run).to install_ark('confluence').with(
        url: 'https://mirror.example.com/confluence-8.5.4.tar.gz',
        checksum: 'a' * 64
      )
    end
  end
end
