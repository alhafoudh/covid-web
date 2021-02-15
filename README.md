# sk-covid-testing

Webová aplikácia ktorá zobrazuje zoznam odberných miest s objednávaním a ich aktuálna voľná kapacita na daný deň. Dáta sa pravidelne aktualizujú pomocou CRON úlohy.

* Ruby version

2.6.5

* Configuration

See `.env.sample`

* Database creation

`rails db:create`

* Database initialization

`rails db:migrate`

* Services (job queues, cache servers, search engines, etc.)

`clockwork clock.rb`
`sidekiq`

* Deployment instructions

`git push dokku master`

