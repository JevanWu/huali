require 'pry'
class PagesController < ApplicationController
  before_action :authenticate_user!, only: :huali_point

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

  def huali_point
    @point_transactions = current_user.point_transactions.order(:created_at).page(params[:page]).per(3)
  end

  def refer_friend
    @user = User.new
  end

  def contact_callback
    # retrieved_contacts = request.env['omnicontacts.contacts']
    # unless retrieved_contacts.nil?
    #   @contacts = Hash.new
    #   retrieved_contacts.each do |contact|
    #     person = OpenStruct.new
    #     unless contact[:name].nil? && contact[:email].nil?
    #       if contact[:name].nil? 
    #         insert_person_info do
    #           name = /[^@]+/.matchs(contact[:email]).to_s
    #           person.name = name
    #         end
    #       else
    #         insert_person_info do
    #           person.name = contact[:name]
    #         end
    #       end
    #     end
    #   end
    # end
    # @user = request.env['omnicontacts.user']
    
  end

  def insert_person_info
    yield
    person.email = contact[:email]
    @contacts[contact[:name]] = person
  end
end
