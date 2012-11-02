class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :fullname
      t.string :address
      t.string :post_code
      t.string :phone
      t.references :province
      t.references :city
      t.references :area

      t.timestamps
    end
  end
end
