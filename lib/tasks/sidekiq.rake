require 'sidekiq'

namespace :sidekiq do
  desc "Stop sidekiq"
  task :stop do
    system "bundle exec sidekiqctl stop #{pidfile}"
  end

  desc "Start sidekiq"
  task start: :requeue do
    system "nohup bundle exec sidekiq -e #{Rails.env} -P #{pidfile} -C #{config_file}>> #{Rails.root.join("log", "sidekiq.log")} 2>&1 &"
  end

  desc "Restart sidekiq"
  task restart: [:stop, :start]

  desc "Ping sidekiq"
  task :ping do
    system <<-HERE
      if [ -f #{pidfile} ];
        then echo 'sidekiq is running';
        else echo 'sidekiq is not running';
      fi
    HERE
  end

  desc "Requeue dangling sidekiq workers"
  task :requeue do
    Sidekiq::Workers.new.each do |name, work, started_at|
      Sidekiq::Client.push work['payload'].except('jid', 'enqueued_at', 'run_at')
    end
    # FIXME, better to manipulate on individual workers one by one
    reset_worker_list
  end

  def pidfile
    Rails.root.join("tmp", "pids", "sidekiq.pid")
  end

  def config_file
    Rails.root.join("config", "sidekiq.yml")
  end

  # methods fetched from Sidekiq core
  def reset_worker_list
    Sidekiq.redis do |conn|
      workers = conn.smembers('workers')
      conn.srem('workers', workers) if !workers.empty?
    end
  end
end
