class AddInFooterSwitchToPage < ActiveRecord::Migration
  def change
    add_column :pages, :in_footer, :boolean, default: true
  end
end
