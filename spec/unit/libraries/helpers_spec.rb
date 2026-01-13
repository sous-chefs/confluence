require 'spec_helper'
require_relative '../../../libraries/helpers'

describe Confluence::Cookbook::Helpers do
  let(:helper_class) do
    Class.new do
      include Confluence::Cookbook::Helpers

      attr_accessor :node

      def initialize(node = {})
        @node = node
      end
    end
  end

  let(:node) { { 'kernel' => { 'machine' => 'x86_64' } } }
  let(:helper) { helper_class.new(node) }

  describe '#confluence_arch' do
    context 'when machine is x86_64' do
      it 'returns x64' do
        expect(helper.confluence_arch).to eq('x64')
      end
    end

    context 'when machine is not x86_64' do
      let(:node) { { 'kernel' => { 'machine' => 'i686' } } }

      it 'returns x32' do
        expect(helper.confluence_arch).to eq('x32')
      end
    end
  end

  describe '#confluence_service_name' do
    it 'returns confluence' do
      expect(helper.confluence_service_name).to eq('confluence')
    end
  end

  describe '#default_confluence_user' do
    it 'returns confluence' do
      expect(helper.default_confluence_user).to eq('confluence')
    end
  end

  describe '#default_confluence_group' do
    it 'returns confluence' do
      expect(helper.default_confluence_group).to eq('confluence')
    end
  end

  describe '#default_home_path' do
    it 'returns the default home path' do
      expect(helper.default_home_path).to eq('/var/atlassian/application-data/confluence')
    end
  end

  describe '#default_install_path' do
    it 'returns the default install path' do
      expect(helper.default_install_path).to eq('/opt/atlassian/confluence')
    end
  end

  describe '#default_jvm_minimum_memory' do
    it 'returns 256m' do
      expect(helper.default_jvm_minimum_memory).to eq('256m')
    end
  end

  describe '#default_jvm_maximum_memory' do
    it 'returns 1024m' do
      expect(helper.default_jvm_maximum_memory).to eq('1024m')
    end
  end

  describe '#default_catalina_opts' do
    it 'returns empty string' do
      expect(helper.default_catalina_opts).to eq('')
    end
  end

  describe '#default_tomcat_port' do
    it 'returns 8090' do
      expect(helper.default_tomcat_port).to eq('8090')
    end
  end

  describe '#default_tomcat_shutdown_port' do
    it 'returns 8000' do
      expect(helper.default_tomcat_shutdown_port).to eq('8000')
    end
  end

  describe '#default_tomcat_max_threads' do
    it 'returns 150' do
      expect(helper.default_tomcat_max_threads).to eq('150')
    end
  end

  describe '#default_tomcat_accept_count' do
    it 'returns 100' do
      expect(helper.default_tomcat_accept_count).to eq('100')
    end
  end

  describe '#default_tomcat_proxy_name' do
    it 'returns nil' do
      expect(helper.default_tomcat_proxy_name).to be_nil
    end
  end

  describe '#default_tomcat_proxy_port' do
    it 'returns nil' do
      expect(helper.default_tomcat_proxy_port).to be_nil
    end
  end

  describe '#default_tomcat_scheme' do
    it 'returns http' do
      expect(helper.default_tomcat_scheme).to eq('http')
    end
  end

  describe '#confluence_download_url' do
    context 'with standalone install type' do
      it 'returns the standalone tarball URL' do
        url = helper.confluence_download_url('8.5.4', 'standalone')
        expect(url).to eq('https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-8.5.4.tar.gz')
      end
    end

    context 'with installer install type' do
      it 'returns the installer URL with architecture' do
        url = helper.confluence_download_url('8.5.4', 'installer')
        expect(url).to eq('https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-8.5.4-x64.bin')
      end
    end

    context 'with unknown install type' do
      it 'raises ArgumentError' do
        expect { helper.confluence_download_url('8.5.4', 'unknown') }.to raise_error(ArgumentError, /Unknown install_type/)
      end
    end
  end

  describe '#confluence_installed_version' do
    context 'when pom.properties exists' do
      it 'returns the version from the file' do
        allow(File).to receive(:exist?).and_return(true)
        allow(File).to receive(:read).and_return("version=8.5.4\n")

        expect(helper.confluence_installed_version('/opt/atlassian/confluence')).to eq('8.5.4')
      end
    end

    context 'when pom.properties does not exist' do
      it 'returns nil' do
        allow(File).to receive(:exist?).and_return(false)

        expect(helper.confluence_installed_version('/opt/atlassian/confluence')).to be_nil
      end
    end
  end

  describe '#systemd_unit_path' do
    it 'returns /etc/systemd/system' do
      expect(helper.systemd_unit_path).to eq('/etc/systemd/system')
    end
  end
end
