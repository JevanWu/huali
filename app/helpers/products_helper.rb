module ProductsHelper
  def link_to_add_assets(name, f, association)
    new_asset = Asset.new
    id = new_asset.object_id
    fields = f.fields_for(association, new_asset, child_index: id) do |builder|
      render('asset_fields', f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub('\n', '')})
  end
end
