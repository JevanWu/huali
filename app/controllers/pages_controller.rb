class PagesController < ApplicationController
  def show
    @page = Page.find_by_permalink!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def partner
  end

  def home
    @menu_nav_type = 'home'
    @slides = SlidePanel.visible
  end

  def brands
  end

  def celebrities
  end

  def weibo_stories
  end

  def christmas
  end

  def valentine
  end

  def white_day
  end

  def pick_up
  end

  def refer_friend
    @user = User.new
  end

  def contact_callback
    retrieved_contacts = request.env['omnicontacts.contacts']
    unless retrieved_contacts.nil?
      @contacts = Array.new
      retrieved_contacts.each do |c|
        next if c[:email].nil?
        contact = OpenStruct.new
        name = c[:name].nil? ? c[:email] : c[:name]
        contact.name = name
        contact.email = c[:email]
        @contacts << contact
      end
    end
    @user = User.new
    render :refer_friend
    # @user = request.env['omnicontacts.user']
  end
end
