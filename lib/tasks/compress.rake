namespace :assets do
  desc "compress assets stored by Paperclip"
  task :compress do
    system <<-CMD
    for file in `find #{Rails.root}/public/system/ -name '*.[jJ][pP][gG]'`; do
      jpegoptim -vtm80 --strip-all $file
    done
    CMD

    system <<-CMD
    for file in `find #{Rails.root}/public/system/ -name '*.[pP][nN][gG]'`; do
      optipng -o5 $file
    done
    CMD
  end

  desc "compress assets in app/assets/images"
  task :compress_app do
    system <<-CMD
    for file in `find #{Rails.root}/app/assets/images/ -name '*.[jJ][pP][gG]'`; do
      jpegoptim -vtm80 --strip-all $file
    done
    CMD

    system <<-CMD
    for file in `find #{Rails.root}/app/assets/images/ -name '*.[pP][nN][gG]'`; do
      optipng -o5 $file
    done
    CMD
  end
end
