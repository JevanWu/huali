require 'spec_helper_full'

describe OrderForm do

  before do
    @product = FactoryGirl.create(:product)
    @coupon = FactoryGirl.create(:coupon)
    @province = FactoryGirl.create(:province)
    @city = @province.cities.sample
    @area = @city.areas.sample
  end

  let(:valid_receiver) do
    {
      fullname: '张佳婵',
      phone: '13912341234',
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
      phone: '13912341234',
      email: 'somebody@example.com'
    }
  end

  let(:valid_line_item) do
    { product_id: @product.id, quantity: Forgery(:basic).number }
  end

  let(:valid_order) do
    {
      # nested attributes
      sender: valid_sender,
      address: valid_receiver,
      line_items: [valid_line_item],
      # direct attributes
      coupon_code: @coupon.code,
      gift_card_text: Forgery(:lorem_ipsum).paragraph,
      special_instructions: Forgery(:lorem_ipsum).paragraph,
      source: '淘宝',
      expected_date: '2013-08-01'
    }
  end

  describe '#save' do
    before do
      OrderForm.new(valid_order).send(:persist!)
    end

    subject { Order.first }

    it { subject.sender_email.should == 'somebody@example.com'}
  end
end
