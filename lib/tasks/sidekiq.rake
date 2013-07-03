namespace :sidekiq do
  desc "Stop sidekiq"
  task :stop do
    system "bundle exec sidekiqctl stop #{pidfile}"
  end

  desc "Start sidekiq"
  task :start do
    system "nohup bundle exec sidekiq -e #{Rails.env} -P #{pidfile} -C #{config_file}>> #{Rails.root.join("log", "sidekiq.log")} 2>&1 &"
  end

  desc "Requeue dangling sidekiq workers"
  task :requeue do
    Sidekiq::Workers.each do |name, work, started_at|
      Sidekiq::Client.push work['payload'].except('jid', 'enqueued_at', 'run_at')
    end
    # FIXME, might need to manipulate on individual workers one by one
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
