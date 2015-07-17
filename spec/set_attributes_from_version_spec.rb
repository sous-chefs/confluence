require 'spec_helper'

describe 'confluence::set_attributes_from_version' do
  versions = {
    '5.1.3' => {
      'x32' => 'd2f674befaa4935c553616999efa6966e9ec0455f41026187ba50c38e05beb36',
      'x64' => '68ca52ad18a354ac721f38832088420591ebf4b7392b0e405194d7ebdc5b0e3f',
      'tar' => 'e400dadebe14a956d086dcb36deae2e6e12e0204ec9af49c176d62054c167903'
    },
    '5.7.1' => {
      'x32' => '6c700207c0c2436f0bacf029a10f633e6d1980a60c7097773c56feec4df0b48b',
      'x64' => '6144b112913d3114caaac93f5ee43191d22980ca704f3b53ef7725dff306d1ee',
      'tar' => '17eae4db5f08e7829f465aa6a98d7bcfe30d335afc97c52f57472c91bbe88da8'
    }
  }

  versions.each do |version, sums|
    context "For Confluence v#{version} installer on x86_64 machine" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set['confluence']['version'] = version
          node.set['confluence']['arch'] = 'x64'
        end.converge(described_recipe)
      end

      it 'has the correct url to installer for x64' do
        expect(chef_run.node['confluence']['url']).to eq(
          "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-#{version}-x64.bin")
        expect(chef_run.node['confluence']['checksum']).to eq(sums['x64'])
      end
    end

    context "For Confluence v#{version} installer on i386 machine" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set['confluence']['version'] = version
          node.set['confluence']['arch'] = 'x32'
        end.converge(described_recipe)
      end

      it 'has the correct url to installer for x32' do
        expect(chef_run.node['confluence']['url']).to eq(
          "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-#{version}-x32.bin")
        expect(chef_run.node['confluence']['checksum']).to eq(sums['x32'])
      end
    end

    context "For Confluence v#{version} standalone installation" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set['confluence']['version'] = version
          node.set['confluence']['install_type'] = 'standalone'
        end.converge(described_recipe)
      end

      it 'has the correct url to standalone tar.gz archive' do
        expect(chef_run.node['confluence']['url']).to eq(
          "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-#{version}.tar.gz")
        expect(chef_run.node['confluence']['checksum']).to eq(sums['tar'])
      end
    end
  end
end
