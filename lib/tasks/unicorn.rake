namespace :unicorn do
  desc "Restart unicorn workers"
  task :restart_workers do
    begin
      Process.kill('HUP', pid)
      puts "unicorn workers is restarted"
    rescue Errno::EPERM # changed uid
      puts "No permission to query #{pid}!"
    rescue Errno::ESRCH, Errno::ENOENT
      puts "unicorn master is NOT running."
    rescue
      puts "Unable to determine status for #{pid} : #{$!}"
    end
  end

  def pid
    result = `cat #{pidfile}`
    raise Errno::ENOENT if result.empty?
    return result.to_i
  end

  def pidfile
    Rails.root.join("tmp", "pids", "unicorn.pid")
  end
end
