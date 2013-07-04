namespace :unicorn do
  desc "Restart unicorn workers"
  task :restart_workers do
    begin
      Process.kill('HUP', unicorn_pid)
      puts "unicorn workers is restarted"
    rescue Errno::EPERM # changed uid
      puts "No permission to query #{unicorn_pid}!"
    rescue Errno::ESRCH, Errno::ENOENT
      puts "unicorn master is NOT running."
    rescue
      puts "Unable to determine status for #{unicorn_pid} : #{$!}"
    end
  end

  def unicorn_pid
    result = `cat #{unicorn_pidfile}`
    raise Errno::ENOENT if result.empty?
    return result.to_i
  end

  def unicorn_pidfile
    Rails.root.join("tmp", "pids", "unicorn.pid")
  end
end
