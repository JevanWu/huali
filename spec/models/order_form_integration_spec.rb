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
      expected_date: '2013-08-01'
    }
  end

  let(:form) do
    OrderForm.new(valid_order)
  end

  it_behaves_like "OrderForm::Integration::Shared"

  describe "coupon_code persistance" do
    context 'with passed in coupon_code' do
      it 'saves coupon_code if passed in' do
        OrderForm.new(valid_order.merge({coupon_code: @coupon.code})).save
        order = Order.first
        order.coupon_code.should == @coupon.code
        order.coupon == @coupon
      end
    end
  end
end
