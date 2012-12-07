class AddI18nForPages < ActiveRecord::Migration
  def change
    add_column :pages, :title_en, :string
    add_column :pages, :content_en, :text
    rename_column :pages, :title, :title_zh
    rename_column :pages, :content, :content_zh
  end
end
