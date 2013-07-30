class ReceiverInfo
  include Virtus

  attribute :fullname, String
  attribute :phone, String
  attribute :province_id, String
  attribute :city_id, String
  attribute :area_id, String
  attribute :address, String
  attribute :post_code, String
end

class SenderInfo
  include Virtus

  attribute :name, String
  attribute :email, String
  attribute :phone, String
end

class ItemInfo
  include Virtus
  attribute :id, String
  attribute :quantity, Integer
end

class OrderInfo
  include Virtus

  attribute :coupon_code, String
  attribute :gift_card_text, String
  attribute :special_instructions, String
  attribute :source, String
  attribute :expected_date, Date
end

class OrderForm
  include Virtus

  extend Enumerize
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :user
  attribute :order, OrderInfo
  attribute :sender, SenderInfo
  attribute :receiver, ReceiverInfo
  attribute :items, Array[ItemInfo]

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def add_line_item(id, quantity)
    # use << won't coerce the Item object
    items += [ {id: id, quantity: quantity} ]
  end

  private

  def persist!

  end
end