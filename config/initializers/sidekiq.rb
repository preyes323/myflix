Sidekiq::Extensions.enable_delay!

if Rails.env.development?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
