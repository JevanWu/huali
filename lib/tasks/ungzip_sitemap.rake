namespace :sitemap do
  desc "uncompress the sitemap1.xml.gz"
  task :uncompress do
    Sitemap_file = "sitemap1.xml.gz"
    system("gzip -d #{Rails.root}/public/#{Sitemap_file}")
   end
end
