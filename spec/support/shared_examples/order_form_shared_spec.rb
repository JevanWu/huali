require 'active_support/inflector/methods'
require 'ostruct'

# mock the errors
module ActiveRecord
  class ActiveRecordError < StandardError
  end
end

shared_examples_for "OrderForm::Shared" do
  describe "attributes" do

    it "builds nested SenderInfo on sender" do
      subject.sender.should == SenderInfo.new(valid_sender)
    end

    it "builds nested ReceiverInfo on address" do
      subject.address.should == ReceiverInfo.new(valid_receiver)
    end

    it "builds nested line_items as Array" do
      subject.line_items.should be_a(Array)
      subject.line_items[0].should == ItemInfo.new(valid_line_items[0])
      subject.line_items[1].should == ItemInfo.new(valid_line_items[1])
    end
  end

  describe "#add_line_item" do
    it "pushes ItemInfo to the line_items attribute" do
      subject.add_line_item(12, 2)
      subject.line_items[0].should == ItemInfo.new(valid_line_items[0])
    end
  end

  describe "#fetch_products" do
    xit "" do
      
    end
  end

  describe "#valid?" do
    VALIDATORS = [
                  'OrderProductRegionValidator',
                  'OrderProductDateValidator',
                  # 'OrderItemValidator',
                  'OrderCouponValidator'
                 ]

    let(:sender) { SenderInfo.new }
    let(:receiver) { ReceiverInfo.new }

    before do
      subject.address = receiver
      subject.sender = sender
      VALIDATORS.each do |v| 
        any_instance_of v.constantize, validate: lambda { |order| }
      end
    end

    it "triggers valid? in all nested attributes" do
      mock(sender).valid?
      mock(receiver).valid?
      subject.valid?
    end

    it 'return false when sender is invalid' do
      stub(sender).valid? { false }
      subject.should_not be_valid
    end

    it 'return false when receiver is invalid' do
      stub(receiver).valid? { false }
      subject.should_not be_valid
    end

    VALIDATORS.each do |validator|
      it "calls validate on #{validator} with subject" do
        any_instance_of(validator.constantize) do |v|
          mock(v).validate(subject)
        end

        subject.valid?
      end

      it "never calls validate on #{validator} unless not_yet_shipped" do
        stub(subject).not_yet_shipped? { false }

        any_instance_of(validator.constantize) do |v|
          mock(v).validate(subject).never
        end

        subject.valid?
      end
    end

    it 'is valid only when all validation return true' do
      stub(sender).valid? { true }
      stub(receiver).valid? { true }
      subject.should be_valid
    end
  end

  describe '@record ivar behavior' do
    before(:each) do
      @record = Object.new
      subject.bind_record(@record)
    end

    it "bind_record accepts an object and stores in @record ivar" do
      subject.instance_variable_get(:@record).should == @record
    end

    it 'could read the ivar from record accessor' do
      subject.record.should == @record
    end

    it 'is persisted if @record is set' do
      subject.should be_persisted
    end

    it 'isn\'t persist unless @record is set' do
      subject.instance_variable_set(:@record, nil)
      subject.should_not be_persisted
    end
  end

  describe "#to_key" do
    it 'returns nil if @record is not set' do
      subject.to_key.should be_nil
    end

    it "returns an Array of @record.id" do
      record =  OpenStruct.new(id: 2)
      subject.bind_record(record)
      subject.to_key.should == [2]
    end
  end

  describe "#save" do
    it "returns true if the object is valid and persist doesn't raise error" do
      stub(subject).valid? { true }
      stub(subject).persist! {}
      subject.save.should be_true
    end

    it "returns false if object is not valid" do
      stub(subject).valid? { false }
      stub(subject).persist! {}
      subject.save.should be_false
    end

    it "returns false if persist! raise error from ActiveRecord" do
      stub(subject).valid? { true }
      stub(subject).persist! { raise ActiveRecord::ActiveRecordError }
      subject.save.should be_false
    end

    it "raise error otherthan from ActiveRecord" do
      stub(subject).valid? { true }
      stub(subject).persist! { raise StandardError }
      lambda { subject.save }.should raise_error
    end
  end
end