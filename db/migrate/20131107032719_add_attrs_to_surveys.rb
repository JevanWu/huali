class AddAttrsToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :receiver_age, :string
    add_column :surveys, :relationship, :string
  end
end
