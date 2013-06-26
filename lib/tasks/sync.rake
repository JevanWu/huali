namespace :assets do
  desc "pull the assets from the server"
  task :pull, :server do |t, args|
    host, user, repo = config_server args[:server]

    system("rsync -rvz #{user}@#{host}:~/repositories/#{repo}/shared/system/ public/system")
    system("rsync -rvz --include '*.txt' --include '*.ico' --exclude '*' #{user}@#{host}:~/repositories/#{repo}/shared/ public/")
  end

  desc "push the assets to the server"
  task :push, :server do |t, args|
    host, user, repo = config_server args[:server]

    system("rsync -rvz public/system #{user}@#{host}:~/repositories/#{repo}/shared/")
    system("rsync -rvz --include '*.txt' --include '*.ico' --exclude '*' public/ #{user}@#{host}:~/repositories/#{repo}/shared/")
  end
end

def config_server(server)
  if server == 'production'
    ['42.121.119.155', 'deployer', 'huali-production']
  else
    ['42.121.3.105', 'deployer', 'huali-staging']
  end
end
