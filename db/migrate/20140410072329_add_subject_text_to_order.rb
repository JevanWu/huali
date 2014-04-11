class AddSubjectTextToOrder < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        add_column :orders, :subject_text, :text, default: ""

        LineItem.find_each do |item|
          item.send(:update_order_subject_text)
        end
      end

      dir.down do
        remove_column :orders, :subject_text
      end
    end
  end
end
