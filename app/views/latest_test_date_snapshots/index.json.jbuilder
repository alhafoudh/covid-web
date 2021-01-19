json.array! @latest_test_date_snapshots do |latest_test_date_snapshot|
  json.id latest_test_date_snapshot.id
  json.test_date do
    json.id latest_test_date_snapshot.test_date.id
    json.date latest_test_date_snapshot.test_date.date
  end
  json.test_date_snapshot do
    json.id latest_test_date_snapshot.test_date_snapshot.id
    json.is_closed latest_test_date_snapshot.test_date_snapshot.is_closed
    json.free_capacity latest_test_date_snapshot.test_date_snapshot.free_capacity
  end
end
