json.array! @latest_snapshots do |latest_snapshot|
  json.id latest_snapshot.id
  json.plan_date do
    json.id latest_snapshot.plan_date.id
    json.date latest_snapshot.plan_date.date
  end
  json.snapshot do
    json.id latest_snapshot.snapshot.id
    json.is_closed latest_snapshot.snapshot.is_closed
    json.free_capacity latest_snapshot.snapshot.free_capacity
  end
end
