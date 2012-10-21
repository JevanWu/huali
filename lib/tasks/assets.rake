namespace :assets do
  task :sync do
    exec("rsync -rvz deploy@easymoo:/home/deploy/repositories/changanhua/shared/system/ public/system")
    exec("rsync -rvz --include '*.txt' --include '*.ico' --exclude '*' deploy@easymoo:/home/deploy/repositories/changanhua/shared/ public/")
  end
end
