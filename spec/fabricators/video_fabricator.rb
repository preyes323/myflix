Fabricator(:video) do
  category
  title { Faker::Lorem.sentence(3) }
  description { Faker::Lorem.paragraph(3) }
end
