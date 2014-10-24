# == Schema Information
#
# Table name: daily_phrases
#
#  created_at         :datetime
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  phrase             :text
#  title              :string(255)
#  updated_at         :datetime
#

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
