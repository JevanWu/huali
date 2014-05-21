module ContactsImporter
  class Netease126 < Base

    def success_login?
      super
      page = submit_form
      !page.body.include? "errorpage"
    end

    def get_contacts
      @contacts = Array.new
      retrieved_contacts = query_contacts
      retrieved_contacts.each do |c|
        next if c["EMAIL;type=INTERNET;type=pref"].nil?
        contact = OpenStruct.new
        name = c["FN"] || c["EMAIL;type=INTERNET;type=pref"] 
        contact.name = name
        contact.email = c["EMAIL;type=INTERNET;type=pref"]
        @contacts << contact
      end
      return @contacts
    end

    def signin_url
      'http://mail.126.com/'
    end

    private

    def submit_form
      @login_form["username"] = @username
      @login_form["password"] = @password
      @login_form.action = "https://mail.126.com/entry/cgi/ntesdoor?&df=mail126_letter&from=web&funcid=loginone&iframe=1&language=-1&passtype=1&product=mail126&verifycookie=-1&net=failed&style=-1&race=-2_-2_-2_db&uid=#{@username}hid=10010102"
      page = @login_form.submit
    end

    def query_contacts
      @agent.page.body.scan /\"http:\/\/.*sid=(.+)&.*\"/
      contact_api_url = "http://mail.126.com/contacts/call.do?uid=#{@username}&sid=#{$1}&from=webmail&cmd=newapi.getContacts&vcardver=3.0&ctype=all"
      page = @agent.get(contact_api_url)

      JSON.parse(page.body)["data"]["contacts"]
    end
  end
end
