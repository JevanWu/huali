zhong_shan_shi = Province.find(19).cities.find(217)
shi_xia_qu = zhong_shan_shi.areas.new(name: "市辖区", post_code: "528400", parent_post_code: "442000")
shi_xia_qu.save
