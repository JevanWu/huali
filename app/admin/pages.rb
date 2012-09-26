ActiveAdmin.register Page do
  controller do
    def show
      @page = Page.find_by_permalink!(params[:id])
    end

    def update
      @page = Page.find_by_permalink!(params[:id])
    end

    def edit
      @page = Page.find_by_permalink!(params[:id])
    end

    def destroy
      @page = Page.find_by_permalink!(params[:id])
    end
  end
end
