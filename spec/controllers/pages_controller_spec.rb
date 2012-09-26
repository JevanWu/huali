require 'spec_helper'

describe PagesController do

  # This should return the minimal set of attributes required to create a valid
  # Page. As you add validations to Page, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET show" do
    it "assigns the requested page as @page" do
      page = Page.create! valid_attributes
      get :show, {:id => page.to_param}, valid_session
      assigns(:page).should eq(page)
    end
  end

end
