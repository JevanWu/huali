require 'mechanize'
class ContactsImporter
  def initialize(user_name, passwd, type = "163")
    @username = user_name #"ryancg"
    @password = passwd #"aaa123"
    @signin_url = 'http://mail.163.com/'
    # case type
    # when "163"
    #   ('http://mail.163.com/')
    # end
    # @type = user_name.scan /\@(.+)\./.first.first
    # user = "ryancg@163.com"
  end

  def get_contacts
    agent = Mechanize.new 
    page = agent.get @signin_url
    login_form = page.form
    login_form["username"] = @username
    login_form["password"] = @password
  end
end


