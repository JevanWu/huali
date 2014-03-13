require 'spec_helper'

describe Billing::Notify do
  let(:type) { :notify }

  context 'from Alipay' do
    before(:each) do
      @transaction = { identifier: 'TRd1304120004', paymethod: 'directPay', amount: 0.01 }
      @raw_post = "customdata=%257B%2522identifier%2522%253A%2522TRd1304120004%2522%257D&discount=0.00&payment_type=1&subject=%E7%8F%8A%E7%91%9A+x+1%2C&trade_no=2013041289657896&buyer_email=namiheike%40163.com&gmt_create=2013-04-12+01%3A36%3A22&notify_type=trade_status_sync&quantity=1&out_trade_no=TRd1304120004&seller_id=2088801670489935&notify_time=2013-04-12+01%3A36%3A41&trade_status=TRADE_SUCCESS&is_total_fee_adjust=N&total_fee=0.01&gmt_payment=2013-04-12+01%3A36%3A41&seller_email=tzgbusiness%40gmail.com&price=0.01&buyer_id=2088002468135962&notify_id=1b9ce7393f00673689fa1e4a6b92c5e419&use_coupon=N&sign_type=MD5&sign=385005bf3f789984e365bc2eb8172983 "
      stub(ENV).[]('ALIPAY_EMAIL') { 'tzgbusiness@gmail.com' }
      stub(ENV).[]('ALIPAY_KEY') { 'app_key' }
    end

    subject { Billing::Base.new(type, @transaction, @raw_post) }

    it { should be_success }

    it 'has #trade_no contains the primary id from the trader' do
      subject.trade_no.should == "2013041289657896"
    end

    it 'isnt success if return has other than TRADE_SUCCESS' do
      re = Billing::Base.new(type, @transaction, @raw_post.sub('SUCCESS', 'OTHER'))
      re.should_not be_success
    end

    xit 'isnt success if return doesnt have the right sign' do
      re = Billing::Base.new(type, @transaction, @raw_post << 'a')
      re.should_not be_verified
    end

    it 'isnt success if the amount isnt matched' do
      re = Billing::Base.new(type, @transaction, @raw_post.sub('0.01', '399'))
      re.should_not be_success
    end
  end


  context 'from Paypal' do
    subject { Billing::Base.new(type, @transaction, @raw_post) }

    before(:each) do
      @transaction = { identifier: 'TRd1304100002', paymethod: 'paypal', amount: 0.01 }
      @raw_post = "mc_gross=4.99&invoice=TRd1304100002&protection_eligibility=Eligible&address_status=confirmed&payer_id=JES7PQWW2NRWN&tax=0.00&address_street=1+Main+St&payment_date=22%3A33%3A38+Apr+09%2C+2013+PDT&payment_status=Completed&charset=windows-1252&address_zip=95131&first_name=Yang&mc_fee=0.44&address_country_code=US&address_name=Yang+Steven%27s+Test+Store&notify_version=3.7&custom=&payer_status=verified&business=steven_1359363126_biz%40zenhacks.org&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=A1lV8iVpAYQfUWop9UIdCPZzoi8TAhBTxwoIapZdgd11nNWcSa0HlTlq&payer_email=s-facilitator%40zenhacks.org&txn_id=2LT6036075702851A&payment_type=instant&payer_business_name=Yang+Steven%27s+Test+Store&last_name=Steven&address_state=CA&receiver_email=steven_1359363126_biz%40zenhacks.org&payment_fee=0.44&receiver_id=LBLSSUYXREZSQ&txn_type=web_accept&item_name=%1A%1A+x+1%2C&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&handling_amount=0.00&transaction_subject=%1A%1A+x+1%2C&payment_gross=4.99&shipping=0.00&ipn_track_id=91a0f5ea7b282"
      stub(subject).acknowledge? { true }
    end

    it { should be_success }

    it 'has #trade_no contains the primary id from the trader' do
      subject.trade_no.should == '2LT6036075702851A'
    end

    it 'isnt success if return has not been acknowledged' do
      stub(subject).acknowledge? { false }
      subject.should_not be_success
    end

    it 'isnt success if return has other than Completed' do
      re = Billing::Base.new(type, @transaction, @raw_post.sub('Completed', 'OTHER'))
      stub(re).acknowledge? { true }
      re.should_not be_success
    end

    it 'isnt success if the amount isnt matched' do
      re = Billing::Base.new(type, @transaction, @raw_post.gsub('4.99', '2.99'))
      stub(re).acknowledge? { true }
      re.should_not be_success
    end
  end
end
