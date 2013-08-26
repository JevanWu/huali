require 'spec_helper'

describe PhoneInputHelper do

  let(:phone) { "18621374266" }
  let(:phone_calling_code) { nil }
  let(:default_calling_code) { "+86" }

  let(:phone_input_helper) do
    PhoneInputHelper.new(phone, phone_calling_code, default_calling_code)
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

    context "when the phone is not valid" do
      let(:phone) { "16621374266" }
      let(:phone_calling_code) { "+86" }

      it "returns with the phone passed" do
        subject.should == '16621374266'
      end
    end

    context "when the phone is valid" do
      context "and it's not started with a '+'" do
        let(:phone) { "18621374266" }
        let(:phone_calling_code) { "+86" }

        it "returns the national format of the phone" do
          subject.should == "186 2137 4266"
        end
      end

      context "and it's started with a '+'" do
        let(:phone) { "+41 446681800" }
        let(:phone_calling_code) { "+41" }

        it "returns the international format of the phone with the calling code removed" do
          subject.should == "44 668 18 00"
        end
      end
    end
  end

end
