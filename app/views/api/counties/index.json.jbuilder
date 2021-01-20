json.array! @counties do |county|
  json.id county.id
  json.name county.name
end
