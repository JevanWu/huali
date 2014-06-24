module PostcardsHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new 
    field = f.simple_fields_for(association, new_object, child_index: "new_field") do |builder|
      render "asset_fields", f: builder
    end
    link_to_function name, "add_fields(this, \"#{j(field)}\")"
  end

  def link_to_remove_fields(name)
    link_to_function name, "remove_fields(this)"
  end
end
