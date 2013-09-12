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
end
