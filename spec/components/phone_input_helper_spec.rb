require 'spec_helper_lite'
require 'active_support/core_ext'
require 'phonelib'
require 'phone_input_helper'

describe PhoneInputHelper do

  let(:phone) { "186 2137 4266" }
  let(:phone_calling_code) { nil }
  let(:default_calling_code) { "+86" }

  let(:phone_input_helper) do
    described_class.new(phone, phone_calling_code, default_calling_code)
  end

  before(:all) do
    Phonelib.default_country = "CN"
  end

  describe "#selected_code" do
    subject { phone_input_helper.selected_code }

    context "when the phone is blank" do
      let(:phone) { '' }
      it "returns the default calling code" do
        subject.should == default_calling_code
      end
    end

    context "when the phone is a valid phone" do
      let(:phone) { "+41 44 668 18 00" }

      it "returns the calling code of the phone" do
        subject.should == "+41"
      end
    end

    context "when the phone is not valid" do
      let(:phone) { "16621374266" }
      let(:phone_calling_code) { "+86" }

      it "returns the calling code passed" do
        subject.should == "+86"
      end
    end
  end

  describe "#text_field_value" do
    subject { phone_input_helper.text_field_value }

    context "when the phone is blank" do
      let(:phone) { "" }

      it { should be_blank }
    end

    context "when the phone is not blank" do
      let(:phone) { "+41 44 668 18 00" }
      let(:phone_calling_code) { "" }

      it "returns the phone with removing its calling code" do
        subject.should == "44 668 18 00"
      end
    end
  end

end
