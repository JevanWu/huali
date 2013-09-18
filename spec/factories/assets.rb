# == Schema Information
#
# Table name: assets
#
#  created_at         :datetime
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  viewable_id        :integer
#  viewable_type      :string(255)
#
# Indexes
#
#  index_assets_on_viewable_id    (viewable_id)
#  index_assets_on_viewable_type  (viewable_type)
#

FactoryGirl.define do
  factory :asset do
    image_file_name { 'sample.jpg' }
    image_content_type 'image/jpeg'
    image_file_size 256

    after(:create) do |asset|
      image_file = Rails.root.join("spec/fixtures/#{asset.image_file_name}")

      # cp test image to direcotries
      [:original, :medium, :thumb, :small].each do |size|
        dest_path = asset.image.path(size)
        `mkdir -p #{File.dirname(dest_path)}`
        `cp #{image_file} #{dest_path}`
      end
    end
  end
end
