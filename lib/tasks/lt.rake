namespace :localtunnel do
  desc "Start local tunnel"
  task :start do
    check_install
    start_lt
    start_server
  end

  desc "Stop local tunnel"
  task :stop do
    stop_lt
    stop_server
  end
end

def start_lt(port = 3001)
  unless check_lt
    pid = spawn("lt --port #{port} --host http://dev.zenhacks.org")
    `echo #{pid} > #{lt_pid}`
    puts "localtunnel is starting..."
  else
    puts "localtunnel is running with process #{pid}"
  end
end

def start_server(port = 3001)
  unless check_server
    pid = spawn("rails server --port #{port} 2>&1 > /dev/null")
    `echo #{pid} > #{server_pid}`
    puts "daemon server is starting..."
  else
    puts "daemon server is running with process #{pid}"
  end
end

def stop_lt
  unless check_lt
    puts "localtunnel is not running"
    return
  end
  system("kill #{File.read(lt_pid)}")
  File.delete(lt_pid)
  puts "localtunnel is stopped."
end

def stop_server
  unless check_server
    puts "daemon server is not running"
    return
  end
  system("kill #{File.read(server_pid)}")
  File.delete(server_pid)
  puts "daemon server is stopped."
end

def check_install
  unless system('which lt > /dev/null')
    raise "you need to install localtunnel to use this tasks \n
    run 'npm install -g localtunnel' to install them"
  end
  exit
end

def check_lt
  File.exist?(lt_pid)
end

def check_server
  File.exist?(server_pid)
end

def project_name
  Rails.root.to_s.split('/').last
end

def lt_pid
  "/tmp/#{project_name}_lt_pid"
end

def server_pid
  "/tmp/#{project_name}_server_pid"
end
