module Admin
  module ProductsHelper
    def collection_checkboxes(product)
      checked_collections = product.collections.to_a
      tree = Collection.hash_tree

      ret = <<-HTML
      <li class="check_boxes input required" id="product_collections_input">
        <fieldset class="choices">
          <legend class="label">
            <label>#{t 'activerecord.attributes.product.collections'}<abbr title="必填">*</abbr></label>
          </legend>
          <input id="product_collections_none" name="product[collection_ids][]" type="hidden" value="">
          #{content_tag(:ol, class: 'choices-group collection-list') { parse_tree(tree, checked_collections) }}
        </fieldset>
        #{%(<p class="inline-errors">您需要填写此项</p>) if product.errors[:collections].present?}
      </li>
      HTML

      ret.html_safe
    end

    private

    def parse_tree(tree, checked_collections)
      tree.map do |k, v|
        content_tag :li, class: 'choices', id: "collection-#{k.id}" do
          parent = content_tag :label, class: 'select_it' do
            input = content_tag(:input,
                                nil,
                                type: :checkbox,
                                name: 'product[collection_ids][]',
                                id: "in-collection-#{k.id}",
                                value: k.id,
                                checked: checked_collections.include?(k))
            (input + k.show_name).html_safe
          end

          if v.present?
            children = content_tag(:ul, class: 'children', style: "margin-left:16px") do
              parse_tree(v, checked_collections)
            end
          end

          (parent + children.to_s).html_safe
        end
      end.join.html_safe
    end
  end
end
