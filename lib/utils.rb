module Utils
  def self.split_collection_array(collections)
    array_size = collections.size

    if array_size == 2
      [collections, []]
    else
      left = collections.values_at(* collections.each_index.select {|i| i.even?})
      right = collections.values_at(* collections.each_index.select {|i| i.odd?})
      [left, right]
    end
  end

  #class << self
    #alias_method :old_split_collection_array, :split_collection_array
  #end

  #def self.split_collection_array(collections)
    #array_size = collections.size

    #if array_size <= 12
      #[collections, []]
    #else
      #[collections.take(12), collections[12..-1]]
    #end
  #end

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
