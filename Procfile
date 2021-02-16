web: bundle exec puma -p $PORT -C config/puma.rb
release: bundle exec rails db:migrate
worker: bundle exec sidekiq -c 1
metrics: bundle exec prometheus_exporter -p 9394
