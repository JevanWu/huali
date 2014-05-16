require 'json'
class NeteaseImporter < ContactsImporter

  def get_contacts
    super
    @login_form.action = "https://ssl.mail.163.com/entry/coremail/fcg/ntesdoor2?df=mail163_letter&from=web&funcid=loginone&iframe=1&language=-1&passtype=1&product=mail163&net=t&style=-1&race=-2_81_-2_hz&uid=#{@username}"
    page = @login_form.submit

    page.body.scan /\"http:\/\/.*sid=(.+)&.*\"/
    contact_api_url = "http://twebmail.mail.163.com/contacts/call.do?uid=#{@username}&sid=#{$1}&from=webmail&cmd=newapi.getContacts&vcardver=3.0"

    page = @agent.get(contact_api_url)

    @contacts = Array.new
    retrieved_contacts = JSON.parse(page.body)["data"]["contacts"]
    retrieved_contacts.each do |c|
      next if c["EMAIL;type=INTERNET;type=pref"].nil?
      contact = OpenStruct.new

      name = c["N"].nil? ? c["EMAIL;type=INTERNET;type=pref"] 
      : c["N"].scan(/\;(.+)\;\;\;/).first.first

      contact.name = name
      contact.email = c["EMAIL;type=INTERNET;type=pref"]
      @contacts << contact
    end
    return @contacts
  end
end
