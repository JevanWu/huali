module Utils
  def self.split_collection_array(collections)
    array_size = collections.size

    if array_size == 2
      [collections, []]
    else
      half = array_size % 2 + array_size / 2
      [collections.take(half), collections[half..-1]]
    end
  end

  def self.subscribe_to_mailchimp(email, name = nil)
    gb = Gibbon.new ENV['MAILCHIMP_API_KEY'], timeout: 60
    gb.list_subscribe(
      id: ENV['MAILCHIMP_LIST_ID'],
      email_address: email,
      merge_vars: { FNAME: name },
      double_optin: false,
      update_existing: true,
      replace_interests: true
    )
  end
end
