# == Schema Information
#
# Table name: ckeditor_assets
#
#  assetable_id      :integer
#  assetable_type    :string(30)
#  created_at        :datetime
#  data_content_type :string(255)
#  data_file_name    :string(255)      not null
#  data_file_size    :integer
#  height            :integer
#  id                :integer          not null, primary key
#  type              :string(30)
#  updated_at        :datetime
#  width             :integer
#
# Indexes
#
#  idx_ckeditor_assetable       (assetable_type,assetable_id)
#  idx_ckeditor_assetable_type  (assetable_type,type,assetable_id)
#

class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
                    :url  => "/system/ckeditor_assets/pictures/:id/:style_:basename.:extension",
                    :path => ":rails_root/public/system/ckeditor_assets/pictures/:id/:style_:basename.:extension",
                    :styles => { :content => '800>', :thumb => '118x100#' }

  validates_attachment_size :data, :less_than => 2.megabytes
  validates_attachment_presence :data

  def url_content
    url(:content)
  end
end
