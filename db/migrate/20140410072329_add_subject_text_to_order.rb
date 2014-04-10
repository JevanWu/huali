class AddSubjectTextToOrder < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        add_column :orders, :subject_text, :text, default: ""

        line_items = LineItem.all
        line_items.each do |li|
          subject_text = ""
          if li.order.subject_text.present?
            subject_text = li.order.subject_text + 
              ", #{li.name} x #{li.quantity}"
          else
            subject_text = "#{li.name} x #{li.quantity}" 
          end
          li.order.update_column(:subject_text, subject_text)
        end
      end

      dir.down do
        remove_column :orders, :subject_text
      end
    end
  end
end
