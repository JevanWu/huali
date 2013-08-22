require 'spec_helper_lite'
require 'support/shared_examples/active_model_spec'
require 'support/shared_examples/order_form_shared_spec'
require 'order_form'
require 'order_admin_form'
require 'active_record'
require 'nulldb_helper'
require 'order'
require 'address'
require 'line_item'
require 'coupon'

describe OrderAdminForm do
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
      bypass_date_validation: false,
      bypass_region_validation: false,
      bypass_product_validation: false,
      coupon_code: 'xs134fx',
      gift_card_text: '空白卡片',
      special_instructions: '现在的色调有些冷，请往“巴黎”的色调靠拢。把绣球的颜色调浅些或者加香槟玫瑰，送给女性朋友生日的礼物，尽量粉嫩甜蜜些',
      source: '淘宝',
      expected_date: '2013-08-01'
    }
  end

  subject { OrderAdminForm.new(valid_order) }

  it_behaves_like "ActiveModel::Full"
  it_behaves_like "OrderForm::Shared"
    
  describe "attributes" do
    [:bypass_date_validation, :bypass_region_validation, :bypass_product_validation].each do |attr|
      it "builds #{attr} default to false" do
        order_admin_form = OrderAdminForm.new(valid_order.except(attr))
        order_admin_form.send(attr).should be_false
      end
    end
  end

  describe "valid?" do
    before do
      VALIDATORS.each do |v| 
        any_instance_of v.constantize, validate: lambda { |order| }
      end
    end

    it 'bypass the DateValidator if bypass_date_validation is true' do
      subject.bypass_date_validation = true

      any_instance_of(OrderProductDateValidator) do |v|
        mock(v).validate(subject).never
      end

      subject.valid?
    end

    it 'bypass the RegionValidator if bypass_region_validation is true' do
      subject.bypass_region_validation = true

      any_instance_of(OrderProductRegionValidator) do |v|
        mock(v).validate(subject).never
      end

      subject.valid?
    end

    it 'bypass the ItemValidator if bypass_product_validation is true' do
      subject.bypass_product_validation = true

      any_instance_of(OrderItemValidator) do |v|
        mock(v).validate(subject).never
      end
      
      subject.valid?
    end
  end

  describe "#save" do
    before do
      stub(subject).valid? { true }
    end

    it 'calls ancestors\'s #persisted! if builds from params' do
      any_instance_of(OrderForm) { |form| mock(form).persist!.once }
      subject.save
    end

    it "doesn\'t call #update! if builds from params" do
      any_instance_of(OrderForm, persist!: true)
      mock(subject).update!.never
      subject.save
    end

    it "call #update! if builds from persited record" do
      stub(subject).persisted? { true }
      mock(subject).update!.once
      subject.save
    end
  end

  describe "self.build_from_record" do
    let(:order_param) do
      {

                      :id => 3,
              :identifier => "OR1301200003",
              :item_total => 299.0,
                   :total => 299.0,
           :payment_total => 239.0,
                   :state => "wait_confirm",
    :special_instructions => "请用雅致的手写体打印，如方正静蕾体。如你们实体店在上海，是否可以让我自己书写卡片？",
            :completed_at => nil,
          :gift_card_text => "31岁的天空，梦想才刚起航。谢谢你指引我，太阳的方向。Happy birthday, dear John!\r\n\r\nYours ever,\r\nKay",
           :expected_date => 'Thu, 24 Jan 2013',
            :sender_email => "kay.cjy@gmail.com",
            :sender_phone => "18621563344",
             :sender_name => "陈小姐",
           :delivery_date => 'Thu, 22 Jan 2013',
                  :source => "unknown",
              :adjustment => '+10',
          :ship_method_id => 1,
                 :printed => false,
                    :kind => "normal"
      }
    end

    let(:line_item_param) do
      {
            :id => 6,
    :product_id => 29,
      :quantity => 1
      } 
    end

    let(:coupon_param) do
      {
                 :id => 73,
               :code => "09fad8a2",
         :adjustment => "*0.85",
            :expired => false,
         :expires_at => 'Tue, 31 Dec 2013',
    :available_count => 1,
         :used_count => 0,
               :note => "顾客补偿"
      }
    end

    let(:address_param) do
      {
             :id => 3,
       :fullname => "俞钢",
        :address => "北京西路1701号静安中华大厦1307室，思捷市场咨询有限公司",
      :post_code => "100001",
          :phone => "13472460673",
    :province_id => 9,
        :city_id => 75,
        :area_id => 787
      }
    end

    let(:order_record) do 
      order = Order.new(order_param)
      order.address = Address.new(address_param)
      order.line_items << LineItem.new(line_item_param)
      order.coupon = Coupon.new(coupon_param)
      order
    end

    subject { OrderAdminForm.build_from_record(order_record) }


    it 'populates the sender attribute' do
      subject.sender.should == SenderInfo.new(order_param.slice(:sender_email, 
                                                                :sender_phone, 
                                                                :sender_name)
                                                            .transform_keys{ |key| key.to_s.gsub(/sender_/, '').to_sym })
    end

    it { subject.address.should == ReceiverInfo.new(address_param) }
    it { subject.line_items[0].should == ItemInfo.new(line_item_param) }
    it { subject.coupon_code.should == coupon_param[:code] }

    it 'preserves nil of coupon' do
      order_record.coupon = nil
      subject.coupon_code.should be_nil
    end
    
    it { should be_persisted }

    [:gift_card_text, :special_instructions, :source, :adjustment].each do |attr|
      it "populates #{attr} as String" do
        subject.send(attr).should be_a(String)
        subject.send(attr).should == order_param[attr]
      end
    end

    [:expected_date, :delivery_date].each do |attr|
      it "populates #{attr} as Date" do
        subject.send(attr).should be_a(Date)
        subject.send(attr).should == Date.parse(order_param[attr])
      end
    end
  end
end