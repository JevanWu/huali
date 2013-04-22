module Extension
  module Suggestion

    def suggest_generate(seeds = [], amount = 5)
      result = []
      # part 0, recommendation
      seeds.each do |t|
        Product.find(t).recommendations.each do |p|
          result.push p.id
        end
      end

      # part 1, one special collection
      # FIXME fit for multi collections
      # r.concat(Collection.where(slug: "accessories-and-others").first.suggest_by_random)
      # r.concat(Collection.where(slug: "accessories-and-others").first.suggest_by_priority(amount*0.6.round))
      # part 2, each seed
      # seeds.each do |t|
        # r.concat(Product.find(t).suggest_same_collection_by_random([(amount*0.2).round,1].max))
        # r.concat(Product.find(t).suggest_same_collection_by_priority([(amount*0.2).round,1].max))
      # end
      # unique & remove seed
      times = 0
      while true do
        if (result = result.uniq).count < amount
          # r = r.concat(Product.suggest_by_random((amount - r.count)*0.2.round))
          # r = r.concat(Product.suggest_by_priority((amount - r.count)*1.5.round))
          result = result.concat(Product.suggest_by_sales_volume_totally((amount-result.count)*2)).uniq
          result = result.concat(Product.suggest_by_random((amount)*1)).uniq
        end
        
        result.each do |t|
          if seeds.include?(t)
            result.delete(t)
          end
        end

        if (result = result.uniq).count >= amount
          break
        end

        if (times += 1) == 10
          break
          # avoid while forever
        end
      end

      # r = r.shuffle[0..amount-1]
      result = result[0..amount-1]

      # turn id into product object
      resultTmp = []
      result.each do |t|
        resultTmp << Product.find(t)
      end
      resultTmp
    end

  end
end