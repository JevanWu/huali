module Admin
  module ProductsHelper
    def collection_checkboxes(product)
      checked_collections = product.collections.to_a
      tree = Collection.hash_tree

      collection_list = content_tag(:ol, class: 'choices-group collection-list') do
        parse_tree(tree, checked_collections)
      end

      render 'collection_checkboxes', product: product, collection_list: collection_list
    end

    private

    def parse_tree(tree, checked_collections)
      tree.map do |k, v|
        content_tag :li, class: 'choices', id: "collection-#{k.id}" do
          parent = content_tag :label, class: 'select_it' do
            content_tag(:input,
                        k.show_name,
                        type: :checkbox,
                        name: 'product[collection_ids][]',
                        id: "in-collection-#{k.id}",
                        value: k.id,
                        checked: checked_collections.include?(k))
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
