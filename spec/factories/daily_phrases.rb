FactoryGirl.define do
  factory :daily_phrase do
    title { Forgery(:lorem_ipsum).words(2) }
    phrase { Forgery(:lorem_ipsum).words(15) }
    image_file_name { 'sample.jpg' }
    image_content_type 'image/jpeg'
    image_file_size 256

    after(:create) do |phrase|
      image_file = Rails.root.join("spec/fixtures/#{phrase.image_file_name}")

      [:original, :medium, :thumb, :small].each do |size|
        dest_path = phrase.image.path(size)
        `mkdir -p #{File.dirname(dest_path)}`
        `cp #{image_file} #{dest_path}`
      end
    end
  end
end
