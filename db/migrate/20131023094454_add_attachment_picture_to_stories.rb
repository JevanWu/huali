class AddAttachmentPictureToStories < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.attachment :picture
      t.attachment :author_avatar
    end
  end

  def self.down
    drop_attached_file :stories, :picture
    drop_attached_file :stories, :author_avatar
  end
end
