class AddAttachmentImageToSlidePanels < ActiveRecord::Migration
  def self.up
    change_table :slide_panels do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :slide_panels, :image
  end
end
