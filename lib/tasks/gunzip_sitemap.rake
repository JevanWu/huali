namespace :sitemap do
  desc "uncompress the sitemap gz"
  task :uncompress do
    Dir[Rails.root.join('public') + '*.gz'].each do |zip_file|
      system("gunzip #{zip_file}")
    end
  end
end
