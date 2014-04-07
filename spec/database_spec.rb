require 'spec_helper'

describe 'confluence::database' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
