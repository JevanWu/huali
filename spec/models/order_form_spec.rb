require 'spec_helper_lite'
require 'support/shared_examples/active_model_spec'
require 'support/shared_examples/order_form_shared_spec'
require 'order_form'

describe ReceiverInfo do
  it_behaves_like "ActiveModel::Validations"
  
  describe "attributes" do
    let(:valid_receiver) do
      {
        fullname: '张佳婵',
        phone: '+8613912341234',
        province_id: 1,
        city_id: 12,
        area_id: 13,
        address: '藏龙岛科技园栗庙路6号 湖北美术学院藏龙岛校区 5栋202室',
        post_code: '430200'
      }
    end

    it 'should accept valid receiver' do
      ReceiverInfo.new(valid_receiver).should be_valid
    end

    [:fullname, :address, :phone, :province_id, :city_id, :post_code].each do |attr|
      it "validates the presence of #{attr}" do
        receiver = ReceiverInfo.new(valid_receiver.except(attr))
        receiver.should_not be_valid
        receiver.errors.should be_include(attr)
        receiver.errors.messages.keys.should be_include(attr)
      end
    end

    it 'accepts empty area_id' do
      ReceiverInfo.new(valid_receiver.except(:area_id)).should be_valid
    end
  end
end

describe SenderInfo do
  it_behaves_like "ActiveModel::Validations"

  describe "attributes" do
    let(:valid_sender) do
      {
        name: '张佳婵',
        phone: '13912341234',
        email: 'somebody@example.com'
      }
    end
    [:name, :phone, :email].each do |attr|
      it "validates the presence of #{attr}" do
        receiver = SenderInfo.new(valid_sender.except(attr))
        receiver.should_not be_valid
        receiver.errors.should be_include(attr)
        receiver.errors.messages.keys.should be_include(attr)
      end
    end
  end
end

describe OrderForm do
  it_behaves_like "ActiveModel::Full"
  it_behaves_like "OrderForm::Shared" do
    
    let(:valid_receiver) do
      {
        fullname: '张佳婵',
        phone: '13912341234',
        province_id: 1,
        city_id: 12,
        area_id: 13,
        address: '藏龙岛科技园栗庙路6号 湖北美术学院藏龙岛校区 5栋202室',
        post_code: '430200'
      }
    end

    let(:valid_sender) do
      {
        name: '张佳婵',
        phone: '13912341234',
        email: 'somebody@example.com'
      }
    end

    let(:valid_line_items) do
      [
        { product_id: 12, quantity: 2 },
        { product_id: 13, quantity: 1 }
      ]
    end

    let(:valid_order) do
      {
        # nested attributes
        sender: valid_sender,
        address: valid_receiver,
        line_items: valid_line_items,
        # direct attributes
        coupon_code: 'xs134fx',
        gift_card_text: '空白卡片',
        special_instructions: '现在的色调有些冷，请往“巴黎”的色调靠拢。把绣球的颜色调浅些或者加香槟玫瑰，送给女性朋友生日的礼物，尽量粉嫩甜蜜些',
        source: '淘宝',
        expected_date: '2013-08-01'
      }
    end

    subject { OrderForm.new(valid_order) }
  end
end