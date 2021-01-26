# sk-covid-testing

Webová aplikácia ktorá zobrazuje zoznam odberných miest s objednávaním a ich aktuálna voľná kapacita na daný deň. Dáta sa pravidelne aktualizujú pomocou CRON úlohy.

* Ruby version

2.6.5

* Configuration

```
UPDATE_TEST_DATE_SNAPSHOTS_INTERVAL=15
UPDATE_TEST_DATE_SNAPSHOTS_RATE_LIMIT=1
UPDATE_VACCINATION_DATE_SNAPSHOTS_INTERVAL=15
UPDATE_VACCINATION_DATE_SNAPSHOTS_RATE_LIMIT=1
CACHED_CONTENT_EXPIRATION_MINUTES=15
CACHED_CONTENT_STALE_MINUTES=1
NUM_TEST_DAYS=10
NUM_VACCINATION_DAYS=10
```

* Database creation

`rails db:create`

* Database initialization

`rails db:migrate`

* Services (job queues, cache servers, search engines, etc.)

`clockwork clock.rb`

* Deployment instructions

`git push dokku master`

