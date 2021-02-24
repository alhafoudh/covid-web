SELECT r.id             AS region_id,
       r.name           AS region_name,
       c.id             AS county_id,
       c.name           AS county_name,
       p.id,
       p.title,
       pd.id            AS plan_date_id,
       pd.date          AS plan_date_date,
       cs.id            AS current_snapshot_id,
       cs.is_closed     AS current_snapshot_is_closed,
       cs.free_capacity AS current_snapshot_free_capacity,
       ps.id            AS previous_snapshot_id,
       ps.is_closed     AS previous_snapshot_is_closed,
       ps.free_capacity AS previous_snapshot_free_capacity,
       ls.id            AS latest_snapshot_id,
       ls.enabled       AS latest_snapshot_enabled,
       ls.updated_at    AS updated_at
FROM moms p
         LEFT JOIN regions r on p.region_id = r.id
         LEFT JOIN counties c on r.id = c.region_id
         LEFT JOIN latest_test_date_snapshots ls on ls.mom_id = p.id
         INNER JOIN test_dates pd on ls.test_date_id = pd.id
         LEFT JOIN test_date_snapshots cs on cs.id = ls.test_date_snapshot_id
         LEFT JOIN test_date_snapshots ps on ps.id = ls.previous_snapshot_id
WHERE p.enabled = true
ORDER BY pd.date, r.name, c.name, p.title;
