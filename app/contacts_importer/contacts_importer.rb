class ContactsImporter
  def initialize(user_name, passwd)
    @username = user_name 
    @password = passwd
  end

  def get_contacts
    @agent = Mechanize.new 
    page = @agent.get signin_url
    @login_form = page.form
  end

  def signin_url
    raise NotImplementedError
  end

  def report_error
    raise NotImplementedError
  end
end



