shared_examples_for "OrderForm::Integration::Shared" do
  describe '#save' do
    before(:all) do
      form.save
    end
    
    let(:order) { Order.first }

    context 'sender information' do
      subject { order }

      it 'stores sender_email' do
        subject.sender_email.should == valid_sender[:email]
      end

      it 'stores sender_name' do
        subject.sender_name.should == valid_sender[:name]
      end

      it 'stores sender_phone' do
        subject.sender_phone.should == valid_sender[:phone]
      end
    end

    context 'address information' do
      subject { order.address }

      it { should_not be_nil }

      it 'saves province_id' do
        subject.province_id.should == valid_receiver[:province_id]
      end

      it 'saves city_id' do
        subject.city_id.should == valid_receiver[:city_id]
      end

      it 'saves area_id' do
        subject.area_id.should == valid_receiver[:area_id]
      end

      it 'saves receiver fullname' do
        subject.fullname.should == valid_receiver[:fullname]
      end

      it 'saves phone number' do
        subject.phone.should == valid_receiver[:phone]
      end

      it 'saves detailed address' do
        subject.address.should == valid_receiver[:address]
      end

      it 'saves post_code' do
        subject.post_code.should == valid_receiver[:post_code]
      end
    end

    context 'line_items information' do
      subject { order.line_items }

      it 'saves the each product' do
        subject[0].product == @product1
        subject[1].product == @product2
      end

      it 'saves quantity for each product' do
        subject[0].quantity == valid_line_items[0][:quantity]
        subject[1].quantity == valid_line_items[1][:quantity]
      end
    end

    context 'other information' do
      subject { order }
      it { subject.gift_card_text.should == valid_order[:gift_card_text] }
      it { subject.special_instructions.should == valid_order[:special_instructions] }
    end
  end
end