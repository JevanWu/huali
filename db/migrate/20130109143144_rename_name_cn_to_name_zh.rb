class RenameNameCnToNameZh < ActiveRecord::Migration
  def change
    rename_column :collections, :name_cn, :name_zh
  end
end
