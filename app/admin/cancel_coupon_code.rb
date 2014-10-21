ActiveAdmin.register_page "CancelCouponCode" do
  # content do 
  #   para "hello!"
  #   para "form_tag \"/huali\" do"
  #   para "text_field_tag \"coupon\""
  #   para "submit_tag \"submit\""
  #   para "end"
  # end
  
  content do 
    semantic_form_for :newest_rooms, :builder => ActiveAdmin::FormBuilder do |f|
      f.input :coupon_code, as: Text
      f.submit
    end
  end

  sidebar :help do
    ul do
      li "First Line of Help"
    end
  end

  action_item do
    link_to "Do Stuff", root_path, :method => :get
  end
end
