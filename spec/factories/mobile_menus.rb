# == Schema Information
#
# Table name: mobile_menus
#
#  created_at         :datetime
#  description        :text
#  href               :string(255)
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  name               :string(255)
#  priority           :integer
#  updated_at         :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mobile_menu do
    name { Forgery(:lorem_ipsum).word }
    priority rand(100)
    description { Forgery(:lorem_ipsum).words(10) }
    image_file_name { 'sample.jpg' }
    image_content_type 'image/jpeg'
    image_file_size 256

    after(:create) do |menu|
      image_file = Rails.root.join("spec/fixtures/#{menu.image_file_name}")

      [:original, :medium, :thumb, :small].each do |size|
        dest_path = menu.image.path(size)
        `mkdir -p #{File.dirname(dest_path)}`
        `cp #{image_file} #{dest_path}`
      end
    end
  end
end
