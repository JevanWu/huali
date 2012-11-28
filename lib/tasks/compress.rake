namespace :assets do
  desc "compress assets stored by Paperclip"
  task :compress do
    system("jpegoptim -vtm80 --strip-all `find #{Rails.root}/public/system/ -name '*.jpg'`")
    system("optipng -o5 `find #{Rails.root}/public/system -name '*.png'`")
  end
end
