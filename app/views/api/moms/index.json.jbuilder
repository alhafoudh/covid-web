json.array! @moms do |mom|
  json.type mom.type
  json.id mom.id
  json.external_id mom.external_id
  json.title mom.title
  json.reservations_url mom.reservations_url
  json.latitude mom.latitude
  json.longitude mom.longitude
  json.city mom.city
  json.street_name mom.street_name
  json.street_number mom.street_number
  json.postal_code mom.postal_code
  json.region_id mom.region_id
  json.region_name mom.region_name
  json.county_id mom.county_id
  json.county_name mom.county_name
end
