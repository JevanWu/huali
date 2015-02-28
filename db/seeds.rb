dong_guan_shi = Province.find(19).cities.find(216)
shi_xia_qu = dong_guan_shi.areas.new(name: "市辖区", post_code: "523000", parent_post_code: "510000")
shi_xia_qu.save
