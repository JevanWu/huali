namespace :assets do

  desc "pull the assets from the changanflowers.com server"
  task :pull do
    exec("rsync -rvz deploy@easymoo:/home/deploy/repositories/changanhua/shared/system/ public/system")
    exec("rsync -rvz --include '*.txt' --include '*.ico' --exclude '*' deploy@easymoo:/home/deploy/repositories/changanhua/shared/ public/")
  end


  desc "push the assets to the changanflowers.com server"
  task :push do
    exec("rsync -rvz public/system deploy@easymoo:/home/deploy/repositories/changanhua/shared/system/")
    exec("rsync -rvz --include '*.txt' --include '*.ico' --exclude '*' public/ deploy@easymoo:/home/deploy/repositories/changanhua/shared/")
  end
end
