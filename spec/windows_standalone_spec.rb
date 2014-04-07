require 'spec_helper'

describe 'confluence::windows_standalone' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
