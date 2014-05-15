require 'json'
def WangyiImporter < ContactsImporter

  def get_contacts
    super

    login_form.action = "https://ssl.mail.163.com/entry/coremail/fcg/ntesdoor2?df=mail163_letter&from=web&funcid=loginone&iframe=1&language=-1&passtype=1&product=mail163&net=t&style=-1&race=-2_81_-2_hz&uid=ryancg@163.com"
    page = login_form.submit

    page.body =~ /\"http:\/\/.*sid=(.+)&.*\"/
    contact_api_url = "http://twebmail.mail.163.com/contacts/call.do?uid=#{@username}&sid=#{$1}&from=webmail&cmd=newapi.getContacts&vcardver=3.0"

    page = agent.get(contact_api_url)

    contacts = JSON.parse page.body
    return contacts["data"]["contacts"] # contact list
  end
end
