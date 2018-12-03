Fabricator(:invitation) do
  recipient_email { Faker::Internet.email }
  recipient_name { Faker::Name.name }
  message { 'Join MyFlix' }
  inviter { Fabricate(:user) }
end
