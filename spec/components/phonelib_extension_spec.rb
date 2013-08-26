require 'active_support/concern'
require 'active_record'
require 'phonelib'
require 'phonelib_extension'
require 'spec_helper_lite'

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
    stub(Phonelib).default_country { "CN" }
  end

  it "create virtual attributes which suffix with '_calling_code'" do
    model.should respond_to(:phone_calling_code)
    model.should respond_to(:sender_phone_calling_code)
  end

  it "sets the value for the virtual attribute" do
    model.phone_calling_code = "+41"
  end

  it "santinizes the phone" do
    model = ActiveRecordModel.new(phone: ["+41", "446681800aaaa"])

    model.phone.should == "+41446681800"
  end

  context "calling code differs from the default country" do
    it "prefixs the attribute with the calling code" do
      model.phone.should == "+41446681800"
    end
  end

  context "calling code is the same as the default country" do
    let(:model) { ActiveRecordModel.new(phone: ["+86", "18621374266"]) }

    it "does not change the phone attribute before validation" do
      model.phone.should == '18621374266'
    end
  end
end
