# encoding: utf-8
ActiveAdmin.register Page do
  menu parent: '设置', if: proc { authorized? :read, Page }

  filter :title_zh
  controller do
    def new
      @page = Page.new
    end

    def create
      @page = Page.new(permitted_params[:page])
      if @page.save
        redirect_to admin_pages_path
      else
        render "new"
      end
    end

    def show
      @page = Page.find_by_permalink!(params[:id])
    end

    def woman_day
    end

    # FIXME cannot update permalink fields
    def update
      @page = Page.find_by_permalink!(params[:id])
      if @page.update_attributes(permitted_params[:page])
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

    private

    def permitted_params
      params.permit page: [:title_zh, :title_en, :permalink, :in_footer, :content_en, :content_zh, :meta_title, :meta_keywords, :meta_description]
    end
  end

  form partial: "form"

  show do

    attributes_table do
      row :permalink
      row :title_en
      row :title_zh
      row :in_footer
      row :content_en do
        markdown(page.content_en)
      end
      row :content_zh do
        markdown(page.content_zh)
      end
      row :meta_title
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

    column :in_footer

    column "Content" do |page|
      markdown(page.content).gsub( %r{</?[^>]+?>}, '' )[0, 40] + '...'
    end

    column "Meta keywords" do |page|
      link_to page.meta_keywords, admin_page_path(page)
    end

    default_actions
  end
end
