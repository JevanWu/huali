require 'spec_helper_full'
require 'support/shared_examples/order_form_integration_shared_spec'

describe OrderForm do
  before(:all) do
    @product1 = FactoryGirl.create(:product)
    @product2 = FactoryGirl.create(:product)
    @province = FactoryGirl.create(:province)
    @user = FactoryGirl.create(:user)
    @city = @province.cities.sample
    @area = @city.areas.sample
    @coupon = FactoryGirl.create(:coupon)
    @ship_method = FactoryGirl.create(:ship_method)
  end

  let(:valid_receiver) do
    {
      fullname: '张佳婵',
      phone: '+86 139 1234 1234',
      province_id: @province.id,
      city_id: @city.id,
      area_id: @area.id,
      address: '藏龙岛科技园栗庙路6号 湖北美术学院藏龙岛校区 5栋202室',
      post_code: @area.post_code
    }
  end

  let(:valid_sender) do
    {
      name: '张佳婵',
      phone: '+86 139 1234 1234',
      email: 'somebody@example.com'
    }
  end

  let(:valid_line_items) do
    [
      { product_id: @product1.id, quantity: Forgery(:basic).number },
      { product_id: @product2.id, quantity: Forgery(:basic).number }
    ]
  end

  let(:valid_order) do
    {
      # nested attributes
      sender: valid_sender,
      address: valid_receiver,
      line_items: valid_line_items,
      user: @user,
      # direct attributes
      gift_card_text: Forgery(:lorem_ipsum).paragraph,
      special_instructions: Forgery(:lorem_ipsum).paragraph,
      source: '淘宝',
      expected_date: '2013-08-01',

      # admin specific
      bypass_date_validation: false,
      bypass_region_validation: false,
      bypass_product_validation: false,
      adjustment: '*0.9',
      kind: :taobao,
      ship_method_id: @ship_method.id,
      delivery_date: '2013-07-31'
    }
  end

  let(:form) do
    OrderAdminForm.new(valid_order)
  end

  it_behaves_like "OrderForm::Integration::Shared"

  describe '#save' do
    describe "coupon_code persistance" do
      context 'with adjustment passed in' do
        it 'shouldn\'t save the coupon on order' do
          OrderAdminForm.new(valid_order.merge({coupon_code: @coupon.code})).save
          order = Order.first

          order.coupon_code.should be_nil
          order.coupon.should be_nil
        end
      end

      context 'without adjustment and with coupon_code' do
        it 'saves coupon_code if passed in' do
          OrderAdminForm.new(valid_order.merge({adjustment: nil, coupon_code: @coupon.code})).save
          order = Order.first

          order.coupon_code.should == @coupon.code
          order.coupon == @coupon
        end
      end
    end
  end

  describe 'Update Behavior when #build_from_record:' do
    before do
      OrderAdminForm.new(valid_order.merge({adjustment:nil, coupon_code: @coupon.code})).save
    end

    let(:form) { OrderAdminForm.build_from_record(order) }
    let(:order) { Order.first }

    it 'doesn\'t create new record' do
      old_order_count = Order.count
      form.save
      Order.count.should == old_order_count
    end

    context 'order information' do
      subject { order }

      it 'updates the adjustment' do
        form.adjustment = '-0.1'
        form.save

        subject.adjustment.should == '-0.1'
      end

      [:gift_card_text, :special_instructions].each do |attr|
        it "updates the #{attr}" do
          updated_attr = Forgery(:lorem_ipsum).paragraph
          form.send("#{attr}=", updated_attr)
          form.save

          subject.send(attr).should == updated_attr
        end
      end
    end

    context 'sender information' do
      subject { order }

      it 'updates with sender_* attributes through SenderInfo' do
        new_email = Forgery(:internet).email_address
        new_name = Forgery(:name).full_name
        new_phone = "+86 10 5908 1615"

        form.sender = SenderInfo.new(email: new_email, name: new_name, phone: new_phone)
        form.save

        subject.sender_email.should == new_email
        subject.sender_name.should == new_name
        subject.sender_phone.should == new_phone
      end
    end

    context 'address=' do
      subject { order.address }

      before(:all) do
        @new_province = FactoryGirl.create(:province)
        @new_city = @new_province.cities.sample
        @new_area = @new_city.areas.sample
      end

      it 'doesn\'t create new address record' do
        old_addr_count = Address.count
        form.address = ReceiverInfo.new(form.address)
        form.save

        Address.count.should == old_addr_count
      end

      it 'updates province/city/area relations' do
        new_address = ReceiverInfo.new(form.address.to_hash
                                       .merge({ province_id: @new_province.id,
                                                city_id: @new_city.id,
                                                area_id: @new_area.id }))
        form.address = new_address
        form.save

        subject.province.should == @new_province
        subject.city.should == @new_city
        subject.area.should == @new_area
      end

      it 'updates other static attributes' do
        new_name = Forgery(:name).full_name
        new_phone = "+86 10 5908 1615"
        new_address = Forgery(:address).street_address
        new_post_code = @new_area.post_code

        new_receiver = ReceiverInfo.new(form.address.to_hash
                                       .merge({ fullname: new_name,
                                                phone: new_phone,
                                                address: new_address,
                                                post_code: new_post_code }))
        form.address = new_receiver
        form.save

        subject.fullname.should == new_name
        subject.phone.should == new_phone
        subject.address.should == new_address
        subject.post_code.should == new_post_code
      end

      it 'preserves relations of user' do
        old_user = subject.user
        new_address = ReceiverInfo.new(form.address.to_hash
                                       .merge({ province_id: @new_province.id,
                                                city_id: @new_city.id,
                                                area_id: @new_area.id }))
        form.address = new_address
        form.save

        subject.user.should == old_user
      end
    end

    context 'user information' do
      subject { order }

      it 'doesn\'t create new user record' do
        old_user_count = User.count
        form.save
        User.count.should == old_user_count
      end

      it 'preserves relations of user' do
        old_user = subject.user
        form.save
        subject.user.should == old_user
      end
    end

    context 'line_items=' do
      subject { order.line_items }

      before(:all) do
        @old_item1, @old_item2 = subject
        @new_product = FactoryGirl.create(:product)
      end

      let(:new_line_items) do
        [
          { product_id: @new_product.id, quantity: Forgery(:basic).number }
        ]
      end

      before(:each) do
        form.line_items = new_line_items
        form.save
      end

      it 'deletes all old LineItem records' do
        lambda { @old_item1.reload }.should raise_error ActiveRecord::RecordNotFound
        lambda { @old_item2.reload }.should raise_error ActiveRecord::RecordNotFound
      end

      it 'builds new LineItem records based on new ItemInfo' do
        subject[0].product == @new_product
      end
    end

    context 'coupon information' do
      subject { order }

      before(:all) do
        @new_coupon = FactoryGirl.create(:coupon)
      end

      it 'updates the coupon relation for new coupon' do
        form.coupon_code = @new_coupon.code
        form.save

        order.coupon_code.should == @new_coupon.code
        order.coupon.should == @new_coupon
      end

      it 'removes the coupon relation for nil coupon' do
        form.coupon_code = nil
        form.save

        order.reload
        order.coupon_code.should be_nil
        order.coupon.should be_nil
      end
    end
  end
end
