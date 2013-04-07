module Suggestion
  class Suggestion
    def initialize(products = [], amount = 10)
      @seeds = products
      @amount = amount
    end

    def result
      r = []
      # part 1, one special collection
      # FIXME fit for multi collections
      r.concat(Collection.where(slug: "accessories-and-others").first.suggest_by_random)
      # part 2, each seed
      @seeds.each do |t|
        r.concat(Product.find(t).suggest_same_collection_by_random((amount*0.3).round))
      end
      # unique & shuffle
      times = 0
      while (r = r.uniq).count < @amount do
        r = r.concat(Product.suggest_by_random(@amount - r.count))
        if (times += 1) == 3
          break
          # avoid while forever
        end
      end
      r.shuffle[0..@amount-1]
    end
  end
end