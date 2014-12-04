class Menues 
  include Draper::LazyHelpers

  attr_accessor :name, :description, :url, :parent,
    :children, :two_column_child_menu, :type

  def initialize(name, description, type, url, parent = nil)
    @name = name
    @description = description
    @type = type
    @url = url
    @parent = parent
  end

  def children
    @children ||= []
  end

  def add_child(child_menu)
    child_menu.parent = self
    children << child_menu
  end

  def splitted_children
    Utils.split_collection_array(children)
  end

  def has_two_column_child_menus?
    @type == :collection && children.all? { |child| child.type == :collection } &&
      splitted_children.last.present?
  end

  private

  def self.new_from_collection(collection, parent = nil)
    Menu.new(collection.display_name,
             collection.description,
             :collection,
             Rails.application.routes.url_helpers.collection_products_path(collection),
             parent)
  end

  def self.new_from_product(product, parent = nil)
    Menu.new(product.name,
             '',
             :product,
             Rails.application.routes.url_helpers.product_path(product),
             parent)
  end
end

