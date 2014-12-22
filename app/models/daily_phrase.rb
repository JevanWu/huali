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

class DailyPhrase < ActiveRecord::Base

  validates_presence_of :phrase, :image

  has_attached_file :image, styles: { medium: "400x200>", thumb: "100x50>" }

end
