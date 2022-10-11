# frozen_string_literal: true

RSpec.describe Faraday::JWT do
  it 'has a version number' do
    expect(Faraday::JWT::VERSION).not_to be nil
  end
end
