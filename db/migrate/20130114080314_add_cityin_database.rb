# encoding: utf-8
class Province < ActiveRecord::Base
end

class City < ActiveRecord::Base
end

class AddCityinDatabase < ActiveRecord::Migration
  def up
    cities = [
      [346, 710000, "台湾", 710000],
      [347, 810000, "香港", 810000],
      [348, 820000, "澳门", 820000]
    ]

    cities.each do |city|
      id, post_code, name, parent_post_code = city
      City.create!(post_code: post_code, name: name, parent_post_code: parent_post_code)
    end
  end

  def down
    City.delete[346, 347, 348]
  end
end
