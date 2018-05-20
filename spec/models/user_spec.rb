require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should have_secure_password }
  it { should have_many(:my_queues).order('position DESC') }
end
