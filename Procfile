web: bundle exec rails server -p $PORT
cron: bundle exec clockwork clock.rb
release: bundle exec rails db:migrate
worker: bundle exec sidekiq -c 1
