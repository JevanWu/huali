# == Schema Information
#
# Table name: administrators
#
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  role                   :string(255)      default("admin"), not null
#  sign_in_count          :integer          default(0)
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_administrators_on_email                 (email) UNIQUE
#  index_administrators_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'spec_helper'

describe Administrator do

  before(:each) do
    @attr = {
      :email => "administrator@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given a valid attribute" do
    Administrator.create!(@attr)
  end

  it "should require an email address" do
    no_email_administrator = Administrator.new(@attr.merge(:email => ""))
    no_email_administrator.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[administrator@foo.com THE_administrator@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_administrator = Administrator.new(@attr.merge(:email => address))
      valid_email_administrator.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[administrator@foo,com administrator_at_foo.org example.administrator@foo.]
    addresses.each do |address|
      invalid_email_administrator = Administrator.new(@attr.merge(:email => address))
      invalid_email_administrator.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    Administrator.create!(@attr)
    administrator_with_duplicate_email = Administrator.new(@attr)
    administrator_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    Administrator.create!(@attr.merge(:email => upcased_email))
    administrator_with_duplicate_email = Administrator.new(@attr)
    administrator_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @administrator = Administrator.new(@attr)
    end

    it "should have a password attribute" do
      @administrator.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @administrator.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      Administrator.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      Administrator.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      Administrator.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @administrator = Administrator.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @administrator.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @administrator.encrypted_password.should_not be_blank
    end

  end

end
