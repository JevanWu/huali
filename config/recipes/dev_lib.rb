namespace :dev_lib do
  task :install do
    # nokogiri dependencies
    run "#{sudo} apt-get install libxslt-dev libxml2-dev"
  end
end