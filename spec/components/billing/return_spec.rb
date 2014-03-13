require 'spec_helper'

describe Billing::Return do
  let(:type) { :return }

  context 'from Alipay' do
    before(:each) do
      @transaction = { identifier: 'TR1302200011', paymethod: 'directPay', amount: 329.00 }
      @query_str = "buyer_email=sniper_eagle%40163.com&buyer_id=2088002511212114&exterface=create_direct_pay_by_user&is_success=T&notify_id=RqPnCoPT3K9%252Fvwbh3I73%252FoH6FPP49gyMfLDeJ3rI0KW%252Fj0IFLsUwFfBUrpQQro%252F2Hy6u&notify_time=2013-02-20+16%3A29%3A18&notify_type=trade_status_sync&out_trade_no=TR1302200011&payment_type=1&seller_email=tzgbusiness%40gmail.com&seller_id=2088801670489935&subject=%E7%8F%8A%E7%91%9A+x+1%2C&total_fee=329.00&trade_no=2013022001197311&trade_status=TRADE_SUCCESS&sign=d4c42425dc944ff104936f6cdeb84b59&sign_type=MD5"
      stub(ENV).[]('ALIPAY_EMAIL') { 'tzgbusiness@gmail.com' }
      stub(ENV).[]('ALIPAY_KEY') { 'app_key' }
    end

    subject { Billing::Base.new(type, @transaction, @query_str) }

    it { should be_success }

    it 'has #trade_no contains the primary id from the trader' do
      subject.trade_no.should == '2013022001197311'
    end

    it 'isnt success if return has other than TRADE_SUCCESS' do
      re = Billing::Base.new(type, @transaction, @query_str.sub('SUCCESS', 'OTHER'))
      re.should_not be_success
    end

    xit 'isnt success if return doesnt have the right sign' do
      re = Billing::Base.new(type, @transaction, @query_str << 'a')
      re.should_not be_verified
    end

    it 'isnt success if the amount isnt matched' do
      re = Billing::Base.new(type, @transaction, @query_str.sub('329', '399'))
      re.should_not be_success
    end
  end

  context 'from Paypal' do
    before(:each) do
      @transaction = { identifier: 'TR1302200011', paymethod: 'paypal', amount: 329.00 }
      @query_str = "custom_id=TR1302200011&tx=1EM7156844322243K&st=Completed&amt=54.99&cc=USD&cm=&item_number="

    end

    subject { Billing::Base.new(type, @transaction, @query_str) }

    it { should be_success }

    it 'has #trade_no contains the primary id from the trader' do
      subject.trade_no.should == '1EM7156844322243K'
    end

    it 'isnt success if return has other than Completed' do
      re = Billing::Base.new(type, @transaction, @query_str.sub('Completed', 'OTHER'))
      re.should_not be_success
    end

    it 'isnt success if the amount isnt matched' do
      re = Billing::Base.new(type, @transaction, @query_str.sub('54.99', '52.99'))
      re.should_not be_success
    end
  end
end
