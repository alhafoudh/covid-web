class Mom < Place
  has_many :snapshots, class_name: 'TestDateSnapshot'
  has_many :latest_snapshots, class_name: 'LatestTestDateSnapshot'
end
