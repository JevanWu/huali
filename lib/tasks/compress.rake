namespace :assets do
  def image_regex
    '.*(jpg|png|jpeg)$'
  end

  desc "compress assets stored by Paperclip"
  task :compress do
    system <<-CMD
    for file in `find #{Rails.root}/public/system -iname '*.jpg' -o -iname '*.jpeg'`; do
      jpegoptim -vtm80 --strip-all $file
    done
    CMD

    system <<-CMD
    for file in `find #{Rails.root}/public/system -iname '*.png'`; do
      optipng -o5 $file
    done
    CMD
  end

  desc "compress assets in app/assets/images"
  task :compress_app do
    system <<-CMD
    for file in `find #{Rails.root}/app/assets/images -iname '*.jpg' -o -iname '*.jpeg'`; do
      jpegoptim -vtm80 --strip-all $file
    done
    CMD

    system <<-CMD
    for file in `find #{Rails.root}/app/assets/images -iname '*.png'`; do
      optipng -o5 $file
    done
    CMD
  end
end
