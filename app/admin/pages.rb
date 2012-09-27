ActiveAdmin.register Page do
  controller do
    def new
      @page = Page.new
    end

    def create
      @page = Page.new(params[:page])
      if @page.save
        redirect_to admin_pages_path
      else
        render "new"
      end
    end

    def show
      @page = Page.find_by_permalink!(params[:id])
    end

    def update
      @page = Page.find_by_permalink!(params[:id])
      if @page.update_attributes(params[:page])
        redirect_to admin_page_path 
      else
        render "edit"
      end
    end

    def edit
      @page = Page.find_by_permalink!(params[:id])
    end

    def destroy
      @page = Page.find_by_permalink!(params[:id])
      @page.destroy
      redirect_to admin_pages_path
    end
  end
end
