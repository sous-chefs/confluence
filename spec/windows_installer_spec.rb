require 'spec_helper'

describe 'confluence::windows_installer' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
