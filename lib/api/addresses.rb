module API
  # Orders API
  class Addresses < Grape::API

    helpers do
      def special_province?
        [/上海/, /重庆/, /北京/, /天津/].any? { |o| o =~ @province.name }
      end
    end

    resource :addresses do
      # Address query.
      #
      # Parameters:
      #   province (required)             - Province name
      #   city (required)                 - City name
      #   area (optional)                 - District name

      # Example Request:
      #   GET /addresses/ids
      params do
        requires :province, type: String
        optional :city, type: String
        optional :area, type: String
      end

      get "ids" do
        if params[:city].blank? && params[:area].blank?
          render_api_error! "Either city or area must be present", 400 and return
        end

        @province =  Province.where("name like ?", "#{params[:province]}%").first
        render_api_error! "Invalid province name #{params[:province]}", 400 and return if @province.blank?

        if special_province?
          @province.cities.each.each do |c|
            @area = c.areas.where("name like ?", "#{params[:area].sub(/(市|区|县)$/, '')}%").first

            if @area.present?
              @city = @area.city
              break
            end
          end

          if @area.blank?
            render_api_error! "Area #{params[:area]} not found in #{params[:province]}", 400 and return
          end
        else
          @city = @province.cities.where("name like ?", "#{params[:city]}%").first

          if @city.blank?
            render_api_error! "City #{params[:city]} not found in province #{params[:province]}", 400 and return
          end

          @area = @city.areas.where("name like ?", "#{params[:area]}%").first
        end

        res = { province_id: @province.id, city_id: @city.id }
        res.merge!(area_id: @area.id) if @area.present?
        res
      end
    end
  end
end
