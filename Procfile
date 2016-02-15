web: bundle exec puma -C config/puma.rb
worker: rake jobs:work --trace
scheduler: rake scheduler:build_backup_queue
