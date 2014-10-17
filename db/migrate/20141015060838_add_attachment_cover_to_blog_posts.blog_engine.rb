# This migration comes from blog_engine (originally 20141014103135)
class AddAttachmentCoverToBlogPosts < ActiveRecord::Migration
  def self.up
    change_table :blog_posts do |t|
      t.attachment :cover
    end
  end

  def self.down
    drop_attached_file :blog_posts, :cover
  end
end
