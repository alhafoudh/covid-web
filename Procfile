web: bundle exec puma -p $PORT -C config/puma.rb
cron: bundle exec clockwork clock.rb
release: bundle exec rails db:migrate
worker: bundle exec sidekiq -c 1
