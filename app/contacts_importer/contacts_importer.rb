class ContactsImporter
  def initialize(user_name, passwd)
    @username = user_name 
    @password = passwd
  end

  def get_contacts
    raise NotImplementedError
  end

  def signin_url
    raise NotImplementedError
  end

  def success_login?
    @agent = Mechanize.new 
    page = @agent.get signin_url
    @login_form = page.form
  end
end



