require 'rails_helper'

RSpec.describe Category do
  it { should have_many(:videos) }
end
