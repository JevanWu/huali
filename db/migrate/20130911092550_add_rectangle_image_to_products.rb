class AddRectangleImageToProducts < ActiveRecord::Migration
  def change
    add_attachment :products, :rectangle_image
  end
end
