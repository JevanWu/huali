require 'spec_helper'

ActiveRecord::Schema.define do
  begin
    create_table :active_record_models do |table|
      table.column :phone, :string
      table.column :sender_phone, :string
    end
  rescue
  end
end

class ActiveRecordModel < ActiveRecord::Base
  phoneize :phone, :sender_phone
end

describe "using model#phoneize" do
  let(:model) { ActiveRecordModel.new(phone: "446681800", phone_calling_code: "+41") }

  before do
    Phonelib.default_country = "CN"
  end

  it "create virtual attributes which suffix with '_calling_code'" do
    ActiveRecordModel.new.should respond_to(:phone_calling_code)
    ActiveRecordModel.new.should respond_to(:sender_phone_calling_code)
  end

  context "calling code differs from the default country" do
    it "prefixs the attribute with the calling code before validation" do
      model.valid?.should be_true
      model.phone.should == "+41 446681800"
    end

    it "sets the phone attribute with international format after model saved" do
      model.save
      model.phone.should == "+41 44 668 18 00"
    end
  end

  context "calling code is the same as the default country" do
    let(:model) { ActiveRecordModel.new(phone: "18621374266", phone_calling_code: "+86") }

    it "does not change the phone attribute before validation" do
      model.phone.should == '18621374266'
    end

    it "set the phone attribute with national format after model saved" do
      model.save
      model.phone.should == "186 2137 4266"
    end
  end
end
