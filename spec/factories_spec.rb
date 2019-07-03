# frozen_string_literal: true

require 'factory_bot'

RSpec.describe 'Factories' do
  it 'should all factories be valid' do
    FactoryBot.factories.map(&:name).each do |factory_name|
      expect(build(factory_name)).not_to be_nil
    end
  end
end
