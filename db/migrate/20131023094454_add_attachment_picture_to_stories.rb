class AddAttachmentPictureToStories < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :stories, :picture
  end
end
