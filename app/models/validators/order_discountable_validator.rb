class OrderDiscountableValidator < ActiveModel::Validator
  def validate(order)
    if order.coupon_code 
      order.line_items.each do |l|
        if l.product.discountable == false
          order.errors[:coupon_code] << "对不起! 您所选择的 '#{l.product.name_zh}' 是不能打折的!"
        end
      end
    end
  end
end
