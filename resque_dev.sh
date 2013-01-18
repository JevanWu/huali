mkdir -p tmp/pids
nohup bundle exec rake environment resque:work QUEUE=mailer VVERBOSE=1 RAILS_ENV=development PIDFILE=tmp/pids/resque_worker.pid > ./log/resque.log  &
