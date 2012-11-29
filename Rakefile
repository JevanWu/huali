#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Huali::Application.load_tasks

# pull in remote database
# taps pull postgres://yangchenyun@localhost/changanhua_development http://httpuser:httppassword@changanflowers.com:5000
#
# pull in remote assets
#rsync -avz deploy@emoo:/home/deploy/repositories/changanhua/shared/system/ public/system
