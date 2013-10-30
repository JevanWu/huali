module Extension
  module MenuNavigator
    extend ActiveSupport::Concern
    included do
      before_action :prepare_menu_list
      helper_method :menu_list
    end

    protected

    def menu_list
      @menu_list ||= []
    end

    def build_collection_menus
      Collection.roots.available.each do |root|
        root_menu = Menu.new_from_collection(root)
        menu_list << root_menu

        children = root.children.available.to_a

        if children.size == 0
          products = root.products.published.limit(10)

          products.each do |product|
            root_menu.add_child(Menu.new_from_product(product))
          end
        else
          children.each do |child_collection|
            child_menu = Menu.new_from_collection(child_collection)
            root_menu.add_child(child_menu)

            products = child_collection.products.published.limit(3)

            products.each do |product|
              child_menu.add_child(Menu.new_from_product(product))
            end
          end
        end
      end
    end

    def build_custom_link_menus
      custom_menu = Menu.new("花里历程", "记录花里从初创至今关于品牌发展与外部合作的历程。您可以在这里更为清晰地了解花里成长的一切。", :link, '#')
      custom_menu.add_child(Menu.new('合作品牌', nil, :link, brands_path))
      custom_menu.add_child(Menu.new('花里·明星', nil, :link, celebrities_path))
      custom_menu.add_child(Menu.new('媒体报道', nil, :link, medias_path))
      menu_list << custom_menu
    end

    def prepare_menu_list
      build_collection_menus
      build_custom_link_menus
    end
  end
end