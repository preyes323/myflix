Fabricator(:my_queue) do
  user
  video
  position { sequence(:position) }
end
