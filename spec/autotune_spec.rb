

require 'spec_helper'

describe 'confluence::autotune' do
  context 'When autotune type is dedicated' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['confluence']['autotune']['enabled'] = true
        node.set['confluence']['autotune']['type'] = 'dedicated'
        node.automatic['memory']['total'] = '8011076kB'
      end.converge(described_recipe)
    end

    it 'the jvm max memory' do
      expect(chef_run.node['confluence']['jvm']['maximum_memory']).to eq('6144m')
    end
    it 'the jvm min memory' do
      expect(chef_run.node['confluence']['jvm']['minimum_memory']).to eq('6144m')
    end
  end

  context 'When autotune type is shared' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['confluence']['autotune']['enabled'] = true
        node.set['confluence']['autotune']['type'] = 'shared'
        node.automatic['memory']['total'] = '8011076kB'
      end.converge(described_recipe)
    end

    it 'the jvm max memory' do
      expect(chef_run.node['confluence']['jvm']['maximum_memory']).to eq('3840m')
    end
    it 'the jvm min memory' do
      expect(chef_run.node['confluence']['jvm']['minimum_memory']).to eq('1920m')
    end
  end

  context 'When autotune type is mixed' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['confluence']['autotune']['enabled'] = true
        node.set['confluence']['autotune']['type'] = 'mixed'
        node.automatic['memory']['total'] = '8011076kB'
      end.converge(described_recipe)
    end

    it 'the jvm max memory' do
      expect(chef_run.node['confluence']['jvm']['maximum_memory']).to eq('5120m')
    end
    it 'the jvm min memory' do
      expect(chef_run.node['confluence']['jvm']['minimum_memory']).to eq('4096m')
    end
  end
end
