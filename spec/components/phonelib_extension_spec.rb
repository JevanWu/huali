require 'spec_helper_lite'
require 'active_support/concern'
require 'active_record'
require 'phonelib'
require 'phonelib_extension'

module Methods
  def phone
    @phone
  end

  def phone=(phone)
    @phone = phone
  end
end

class ActiveRecordModel
  include Methods
  include Phonelib::Extension

  attr_reader :sender_phone

  def initialize(attributes)
    self.phone = attributes[:phone]
  end

  phoneize :phone, :sender_phone
end

describe "using model#phoneize" do
  let(:model) { ActiveRecordModel.new(phone: ["+41", "446681800"]) }

  before(:all) do
    Phonelib.default_country = "CN"
  end

  it "create virtual attributes which suffix with '_calling_code'" do
    model.should respond_to(:phone_calling_code)
    model.should respond_to(:sender_phone_calling_code)
  end

  describe "rewrite the writer of the phoneized attribute" do
    it "sets the value for the virtual attribute" do
      model.phone_calling_code = "+41"
    end

    subject { model.phone }

    describe "santinize phone" do
      context "when the input is a String" do
        context "when the phone is a 400 phone" do
          let(:model) { ActiveRecordModel.new(phone: "400-001-6936") }

          it { should == "4000016936" }
        end

        context "and it's a local phone" do
          let(:model) { ActiveRecordModel.new(phone: "0701356633333aaa") }

          it { should == "0701356633333" }
        end

        context "and it's a international phone" do
          let(:model) { ActiveRecordModel.new(phone: "+41446681800aaa") }

          it { should == "+41446681800" }
        end
      end

      context "when the input is a Array which contains phone an calling code" do
        context "when the phone is a chinese fixed-line number" do
          let(:model) { ActiveRecordModel.new(phone: ["+86", "0701356633333aaa"]) }

          it { should == "0701356633333" }
        end

        context "when the phone is a international phone" do
          let(:model) { ActiveRecordModel.new(phone: ["+41", "446681800aaaa"]) }

          it { should == "+41446681800" }
        end
      end
    end

    context "when calling code differs from the default country" do
      it "prefixs the attribute with the calling code" do
        subject.should == "+41446681800"
      end
    end

    context "when calling code is the same as the default country" do
      let(:model) { ActiveRecordModel.new(phone: ["+86", "18621374266"]) }

      it "does not change the phone attribute before validation" do
        subject.should == '18621374266'
      end
    end
  end
end
