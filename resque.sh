mkdir -p tmp/pids
nohup bundle exec rake environment resque:work QUEUE=mailer RAILS_ENV=production PIDFILE=tmp/pids/resque_worker.pid > ./log/resque.log  &
