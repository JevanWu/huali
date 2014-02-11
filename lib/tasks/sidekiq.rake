require 'sidekiq'

namespace :sidekiq do
  desc "Stop sidekiq"
  task :stop do
    system "bundle exec sidekiqctl stop #{sidekiq_pidfile}"
  end

  desc "Start sidekiq"
  task start: :requeue do
    system "nohup bundle exec sidekiq -e #{Rails.env} -P #{sidekiq_pidfile} -C #{config_file}>> #{Rails.root.join("log", "sidekiq.log")} 2>&1 &"
  end

  desc "Restart sidekiq"
  task restart: [:stop, :start]

  desc "Restart if not exist"
  task restart_if_not_exist: :ping do
    begin
      Process.kill(0, sidekiq_pid)
    rescue
      Rake::Task['sidekiq:restart'].invoke
    end
  end

  desc "Ping sidekiq"
  task :ping do
    begin
      Process.kill(0, sidekiq_pid)
      puts "sidekiq is running with pid: #{sidekiq_pid}"
    rescue Errno::EPERM # changed uid
      puts "No permission to query #{sidekiq_pid}!"
    rescue Errno::ESRCH, Errno::ENOENT
      puts "sidekiq is NOT running."
    rescue
      puts "Unable to determine status for #{sidekiq_pid} : #{$!}"
    end
  end

  desc "Requeue dangling sidekiq workers"
  task :requeue do
    Sidekiq::Workers.new.each do |name, work, started_at|
      Sidekiq::Client.push work['payload'].except('jid', 'enqueued_at', 'run_at')
    end
    # FIXME, better to manipulate on individual workers one by one
    reset_worker_list
  end

  def sidekiq_pid
    result = `cat #{sidekiq_pidfile}`
    raise Errno::ENOENT if result.empty?
    return result.to_i
  end

  def sidekiq_pidfile
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

  task :clean_needless_retries do
    query = Sidekiq::RetrySet.new

    query.select do |job|
      job.item['error_class'] == "Twilio::REST::RequestError"
    end.map(&:delete)

    query.select do |job|
      job.item['error_class'] == "ActionView::Template::Error"
    end.map(&:delete)

    query.select do |job|
      job.item['error_class'] == "StandardError" && job.item['error_message'].include?("短信发送未成功")
    end.map(&:delete)

    query.select do |job|
      job.item['error_class'] == "NoMethodError" && job.item['error_message'].include?("nil:NilClass")
    end.map(&:delete)
  end
end
