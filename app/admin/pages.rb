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

    # FIXME cannot update permalink fields
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

  show do |page|

    attributes_table do
      row :permalink
      row :title_en
      row :title_zh
      row :content_en do
        markdown(page.content_en)
      end
      row :content_zh do
        markdown(page.content_zh)
      end
      row :meta_keywords
      row :meta_description
    end
  end

  index do
    selectable_column

    column "Title" do |page|
      page.title
    end

    column "Link" do |page|
      page.permalink
    end

    column "Content" do |page|
      markdown(page.content).gsub( %r{</?[^>]+?>}, '' )[0, 40] + '...'
    end

    column "Meta keywords" do |page|
      link_to page.meta_keywords, admin_page_path(page)
    end

    default_actions
  end
end
