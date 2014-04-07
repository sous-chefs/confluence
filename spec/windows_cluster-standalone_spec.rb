require 'spec_helper'

describe 'confluence::windows_cluster-standalone' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
