# encoding: utf-8
namespace :migrate do
  desc "Update product's collections"
  task update_product_collection: :environment do
    def set_collection_for_products(collection_name, *product_names)
      begin
        collection = Collection.find_by_slug!(collection_name)
      rescue ActiveRecord::RecordNotFound
        puts "Collection <#{collection_name}> not found!"
        raise
      end

      products = product_names.map do |name|
        begin
          Product.find_by_name_zh!(name)
        rescue ActiveRecord::RecordNotFound
          puts "Product <#{name}> not found!"
          raise
        end
      end

      products.each do |product|
        unless collection.products.include?(product)
          collection.products << product
        end
      end
    end

    # 花里精选
    ## 最新产品
    product_names = ["深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市",
      "欧洲花园", "雨叮咚", "淡奶之吻", "软妹子", "星月", "皓夜", "永生·海洋之心",
      "花园梦想"]
    set_collection_for_products("latest-design", *product_names)

    ## 明星产品
    product_names = ["星空下的问候", "红宝石", "紫舞", "秋天的秘密", "蓝宝石",
      "普罗旺斯的一年", "海洋之心"]
    set_collection_for_products("best-seller", *product_names)

    ## 限量定制款
    product_names = ["无双玫瑰", "Surprise Me!"]
    set_collection_for_products("custom-tailor", *product_names)

    ## 永生花
    product_names = ["雨叮咚", "淡奶之吻", "软妹子", "星月", "皓夜", "永生·海洋之心",
      "星空下的问候", "红宝石", "紫舞" , "秋天的秘密", "蓝宝石", "琥珀", "秋天的秘密.mini", "未名·贰", "碧玺"]
    set_collection_for_products("preserved-flower", *product_names)

    ## 鲜花
    product_names = ["花园梦想", "普罗旺斯的一年", "水边的阿狄丽娜", "四季", "绿野仙踪",
      "巴黎", "海洋之心", "甜心", "给柏拉图的信", "国色", "太阳麦田", "雪国", "晨歌", "慕云", "雍容", "白日微澜"]
    set_collection_for_products("fresh-flower", *product_names)

    ## 花束
    product_names = ["水边的阿狄丽娜", "未名·贰"]
    set_collection_for_products("bouquet", *product_names)

    ## 花盒
    product_names = ["雨叮咚", "淡奶之吻", "软妹子", "星月", "皓夜", "永生·海洋之心",
      "星空下的问候", "红宝石", "紫舞", "秋天的秘密", "蓝宝石", "琥珀", "秋天的秘密.mini", "碧玺", "花园梦想",
      "普罗旺斯的一年", "四季", "绿野仙踪", "巴黎", "海洋之心", "甜心", "给柏拉图的信", "国色", "太阳麦田",
      "雪国", "晨歌", "慕云", "雍容", "白日微澜"]
    set_collection_for_products("flower-box", *product_names)

    ## 玫瑰花
    product_names = ["晨歌", "慕云", "雍容", "白日微澜", "给柏拉图的信", "甜心", "雨叮咚",
      "淡奶之吻", "软妹子", "星月", "皓夜", "永生·海洋之心", "星空下的问候", "红宝石",
      "紫舞", "秋天的秘密", "蓝宝石", "琥珀", "秋天的秘密.mini", "未名·贰", "碧玺"]
    set_collection_for_products("rose", *product_names)

    # 生日
    ## 妈妈生日
    product_names = ["弗拉明戈", "雨叮咚", "星空下的问候", "紫舞", "花园梦想", "海洋之心"]
    set_collection_for_products("mother-birthday", *product_names)

    ## 老婆生日
    product_names = ["轻奢世界", "深海之谜", "红宝石", "巴黎", "给柏拉图的信", "雍容"]
    set_collection_for_products("wife-birthday", *product_names)

    ## 朋友生日
    product_names = ["自然香气", "软妹子", "星空下的问候", "蓝宝石", "琥珀", "太阳麦田", "海洋之心"]
    set_collection_for_products("friend-birthday", *product_names)

    ## 女朋友生日
    product_names = ["欧洲花园", "浓情城市", "淡奶之吻", "普罗旺斯的一年", "给柏拉图的信", "晨歌"]
    set_collection_for_products("girlfriend-birthday", *product_names)

    # 节日送花
    ## 父亲节
    product_names = ["星空下的问候", "海洋之心", "永生·海洋之心", "雨叮咚", "碧玺"]
    set_collection_for_products("father-s-day", *product_names)

    ## 情人节
    product_names = ["普罗旺斯的一年", "四季", "软妹子", "淡奶之吻", "红宝石", "紫舞", "蓝宝石",
      "花园梦想", "巴黎", "海洋之心", "雨叮咚", "星月", "星空下的问候", "星月", "皓夜", "秋天的秘密",
      "碧玺", "深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市", "欧洲花园"]
    set_collection_for_products("valentines-day", *product_names)

    ## 妇女节
    product_names = ["普罗旺斯的一年", "四季", "海洋之心", "紫舞", "秋天的秘密", "星空下的问候",
      "皓夜", "花园梦想", "巴黎", "绿野仙踪", "红宝石", "雍容", "国色",
      "深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市", "欧洲花园"]
    set_collection_for_products("woman-s-day", *product_names)

    ## 教师节
    product_names = ["海洋之心", "永生·海洋之心", "雨叮咚", "淡奶之吻", "星月", "皓夜", "星空下的问候",
      "紫舞", "秋天的秘密", "蓝宝石", "碧玺", "花园梦想", "四季", "绿野仙踪", "给柏拉图的信", "雍容"]
    set_collection_for_products("teacher-s-day", *product_names)

    ## 生日
    product_names = ["普罗旺斯的一年", "四季", "海洋之心", "永生·海洋之心", "软妹子", "雨叮咚",
      "淡奶之吻", "星月", "皓夜", "星空下的问候", "秋天的秘密", "花园梦想", "水边的阿狄丽娜",
      "深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市", "欧洲花园"]
    set_collection_for_products("birthday--2", *product_names)

    ## 中秋节
    product_names = ["皓夜", "星月", "秋天的秘密", "秋天的秘密.mini", "星空下的问候"]
    set_collection_for_products("mid-autumn-festival", *product_names)

    ## 七夕
    product_names = ["红宝石", "蓝宝石", "碧玺", "琥珀", "皓夜", "软妹子", "淡奶之吻", "秋天的秘密",
      "深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市", "欧洲花园",
      "海洋之心", "永生·海洋之心", "普罗旺斯的一年", "四季", "花园梦想", "巴黎", "给柏拉图的信"]
    set_collection_for_products("qixi--2", *product_names)

    ## 感恩节
    product_names = ["普罗旺斯的一年", "四季", "花园梦想", "海洋之心", "永生·海洋之心", "琥珀", "碧玺",
      "星空下的问候", "星月", "皓夜", "秋天的秘密",
      "深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市", "欧洲花园"]
    set_collection_for_products("thanksgiving-day", *product_names)

    ## 儿童节
    product_names = ["软妹子", "绿野仙踪"]
    set_collection_for_products("children-s-day", *product_names)

    ## 表白季
    product_names = ["普罗旺斯的一年", "四季", "软妹子", "淡奶之吻", "红宝石", "紫舞", "蓝宝石",
      "花园梦想", "巴黎", "海洋之心", "雨叮咚", "星月", "雨叮咚", "星空下的问候", "星月", "皓夜", "秋天的秘密",
      "深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市", "欧洲花园"]
    set_collection_for_products("love-confession", *product_names)

    ## 致歉季
    product_names = ["普罗旺斯的一年", "四季", "花园梦想", "海洋之心", "永生·海洋之心",
      "琥珀", "碧玺", "星空下的问候", "星月", "皓夜", "秋天的秘密",
      "深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市", "欧洲花园",
      "雨叮咚", "紫舞"]
    set_collection_for_products("apology-flower", *product_names)

    ## 毕业季
    product_names = ["普罗旺斯的一年", "四季", "软妹子", "淡奶之吻", "紫舞", "蓝宝石", "花园梦想",
      "巴黎", "海洋之心", "雨叮咚", "星月", "星空下的问候", "皓夜", "秋天的秘密",
      "深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市", "欧洲花园",
      "绿野仙踪"]
    set_collection_for_products("graduation-season", *product_names)

    ## 周年纪念日
    product_names = ["普罗旺斯的一年", "软妹子", "淡奶之吻", "紫舞", "花园梦想", "巴黎", "海洋之心", "雨叮咚", "星空下的问候"]
    set_collection_for_products("anniversary-gift", *product_names)

    ## 圣诞节
    product_names = ["雨叮咚", "星空下的问候", "秋天的秘密", "琥珀", "秋天的秘密.mini", "碧玺", "花园梦想", "给柏拉图的信"]
    set_collection_for_products("christmas-day", *product_names)

    ## 母亲节
    product_names = ["四季", "海洋之心", "紫舞", "花园梦想", "巴黎", "绿野仙踪", "红宝石", "雍容", "国色",
      "深海之谜", "弗拉明戈", "自然香气", "轻奢世界", "浓情城市", "欧洲花园"]
    set_collection_for_products("mother-s-day", *product_names)

    ## 求婚和婚礼
    product_names = ["普罗旺斯的一年", "软妹子", "淡奶之吻", "花园梦想", "巴黎", "海洋之心", "雨叮咚"]
    set_collection_for_products("propose-and-wedding-flower", *product_names)

    # 鲜花订阅
    ## 三个月
    product_names = ["三个月订阅"]
    set_collection_for_products("three-months-flower-subscription", *product_names)

    ## 六个月
    product_names = ["六个月订阅"]
    set_collection_for_products("6-months-flower-subscription", *product_names)

    ## 一年
    product_names = ["全年订阅"]
    set_collection_for_products("a-year-flower-subscription", *product_names)
  end

  desc "Update collection's visibility"
  task update_collection_visibility: :environment do
    def enable_collections(*collection_slugs)
      collection_slugs.each do |slug|
        begin
          collection = Collection.find_by_slug!(slug)
          collection.update_attribute(:available, true)

          # update child collection
          collection.children.each do |child|
            child.update_attribute(:available, true)
          end
        rescue ActiveRecord::RecordNotFound
          puts "Collection <#{slug}> not found!"
          raise
        end
      end
    end

    # Disablle all collections first
    ActiveRecord::Base.connection.execute("UPDATE collections SET available = false");

    # Then renable needed collections
    collections_to_enable = ["huali-selection", "birthday-selection", "flower-subscription", "special-occasions", "business-gifting", "colorful-life"]
    enable_collections(*collections_to_enable)
  end
end
