module Extension
  module Suggestion

    def suggest_generate(seeds = [], amount = 5)
      r = []
      # part 1, one special collection
      # FIXME fit for multi collections
      # r.concat(Collection.where(slug: "accessories-and-others").first.suggest_by_random)
      r.concat(Collection.where(slug: "accessories-and-others").first.suggest_by_priority(amount*0.6.round))
      # part 2, each seed
      seeds.each do |t|
        # r.concat(Product.find(t).suggest_same_collection_by_random([(amount*0.2).round,1].max))
        r.concat(Product.find(t).suggest_same_collection_by_priority([(amount*0.2).round,1].max))
      end
      # unique & remove seed
      times = 0
      while true do
        if (r = r.uniq).count < amount
          r = r.concat(Product.suggest_by_random((amount - r.count)*0.2.round))
          r = r.concat(Product.suggest_by_priority(amount - r.count)
        end

        r.each do |t|
          if seeds.include?(t)
            r.delete(t)
          end
        end

        if r.count >= amount
          break
        end

        if (times += 1) == 10
          break
          # avoid while forever
        end
      end

      r.shuffle[0..amount-1]

      # turn id into product object
      rt = []
      r.each do |t|
        rt << Product.find(t)
      end
      rt
    end

  end
end