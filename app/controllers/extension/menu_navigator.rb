module Extension
  module MenuNavigator
    extend ActiveSupport::Concern
    included do
      helper_method :menu_list
    end

    protected

    def menu_list
      @menu_list ||= []

      Rails.cache.fetch('menu_list', expires_in: 30.day) do
        prepare_menu_list
        @menu_list
      end
    end

    def build_collection_menus
      Collection.roots.available.each do |root|
        root_menu = Menu.new_from_collection(root)
        @menu_list << root_menu

        children = root.children.available.to_a

        # children.each do |child_collection|
        #   child_menu = Menu.new_from_collection(child_collection)
        #   root_menu.add_child(child_menu)

        #   products = child_collection.products.published.limit(3)

        #   products.each do |product|
        #     child_menu.add_child(Menu.new_from_product(product))
        #   end
        # end
      end
    end

    def build_custom_link_menus
      # custom_menu = Menu.new("花里历程", "记录花里从初创至今关于品牌发展与外部合作的历程。您可以在这里更为清晰地了解花里成长的一切。", :link, '#')
      # custom_menu.add_child(Menu.new('合作品牌', nil, :link, brands_path))
      # custom_menu.add_child(Menu.new('花里·明星', nil, :link, celebrities_path))
      # custom_menu.add_child(Menu.new('媒体报道', nil, :link, medias_path))
      # custom_menu.add_child(Menu.new('花里博客', nil, :link, blog_path))
      # @menu_list << custom_menu
      @menu_list << Menu.new("HualiGirls", "", :link, weibo_stories_path)
      @menu_list << Menu.new("实体店铺", "", :link, offline_shop_path)
    end

    def prepare_menu_list
      @menu_list << Menu.new("花里首页", nil, :link, '/')
      @menu_list << Menu.new("2.14情人节", nil, :link, '/valentine_2015')
      build_collection_menus
      build_custom_link_menus
    end
  end
end
