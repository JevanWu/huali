module Extension
  module MenuNavigator
    extend ActiveSupport::Concern
    included do
      helper_method :menu_list
    end

    protected

    def menu_list
      @menu_list ||= []

      @menu_list = Menu.available
    end
  end
end
