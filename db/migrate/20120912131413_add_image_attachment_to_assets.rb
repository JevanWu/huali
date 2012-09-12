class AddImageAttachmentToAssets < ActiveRecord::Migration
  def change
    add_attachment :assets, :image
  end
end
