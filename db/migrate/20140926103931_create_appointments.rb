class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :user, index: true
      t.references :product, index: true
      t.string :phone
      t.string :email
      t.datetime :notify_at

      t.timestamps
    end
  end
end
