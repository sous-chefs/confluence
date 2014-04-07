require 'spec_helper'

describe 'confluence::windows_war' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
