Fabricator(:video_review) do
  user
  video
  review { Faker::Lorem.paragraph }
  rating { (1..5).to_a.sample }
end
