require 'spec_helper'
describe 'cyberlab' do

  context 'with defaults for all parameters' do
    it { should contain_class('cyberlab') }
  end
end
