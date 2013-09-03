require 'spec_helper_lite'
require 'active_support/concern'
require 'active_record'
require 'phonelib'
require 'phonelib_extension'

class SuperPhoneModel
  attr_accessor :phone

  def phone_before_type_cast
    @phone
  end
end

class FakePhoneModel < SuperPhoneModel
  include Phonelib::Extension

  attr_reader :sender_phone

  def initialize(attributes)
    self.phone = attributes[:phone]
  end

  phoneize :phone, :sender_phone
end

describe "using model#phoneize" do
  let(:model) { FakePhoneModel.new(phone: ["+41", "446681800"]) }

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

    subject { model.phone_before_type_cast }

    describe "santinize phone" do
      context "when the phone is a chinese fixed-line number" do
        let(:model) { FakePhoneModel.new(phone: ["+86", "0701356633333aaa"]) }

        it { should == "+86701356633333" }
      end

      context "when the phone is a international phone" do
        let(:model) { FakePhoneModel.new(phone: ["+41", "446681800aaaa"]) }

        it { should == "+41446681800" }
      end
    end

    context "when calling code differs from the default country" do
      it "prefixs the attribute with the calling code" do
        subject.should == "+41446681800"
      end
    end

    context "when calling code is the same as the default country" do
      let(:model) { FakePhoneModel.new(phone: ["+86", "18621374266"]) }

      it "prefixs the attribute with the calling code of the default country" do
        subject.should == '+8618621374266'
      end
    end

    context "when the input is a valid String phone with international format" do
      let(:model) { FakePhoneModel.new(phone: "+41 44 668 18 00") }

      it "was saved successfully as the Array phone input" do
        subject.should == "+41446681800"
      end
    end
  end

  describe "rewrite the reader of the phoneized attribute" do
    context "when original phone is valid" do
      context "and it's a international phone" do
        let(:model) { FakePhoneModel.new(phone: ["+41", "446681800"]) }

        it "returns the international form of the phone" do
          model.phone.should == "+41 44 668 18 00"
        end
      end

      context "and it's a Chinese phone" do
        let(:model) { FakePhoneModel.new(phone: ["+86", "18621374266"]) }

        it "returns the international form of the phone" do
          model.phone.should == "+86 186 2137 4266"
        end
      end
    end

    context "when original phone is not valid" do
      let(:model) { FakePhoneModel.new(phone: ["+41", "4466818000"]) }

      it "returns the original value" do
        model.phone.should == "+414466818000"
      end
    end
  end
end
