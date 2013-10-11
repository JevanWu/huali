require 'spec_helper_lite'
require 'ostruct'
require 'active_model'
require 'order_customized_region_validator'

describe OrderCustomizedRegionValidator do
  let(:valid_rule) do
    OpenStruct.new(
      province_ids: ['1','2','3'],
      city_ids: ['1','2'],
      area_ids: ['1','2','3','4'])
  end

  let(:invalid_rule) do
    OpenStruct.new(
      province_ids: ['2','3'],
      city_ids: ['2'],
      area_ids: ['2','3','4'])
  end

  let(:valid_policy) do
    OpenStruct.new(local_region_rule: valid_rule)
  end

  let(:invalid_policy) do
    OpenStruct.new(local_region_rule: invalid_rule)
  end

  let(:not_open_policy) do
    OpenStruct.new(not_open: true, local_region_rule: valid_rule)
  end

  let(:order_errors) { Object.new }

  let(:address_errors) { Object.new }

  let(:address) do
    Object.new.tap do |addr|
      stub(addr).province_id { 1 }
      stub(addr).city_id { 1 }
      stub(addr).area_id { 1 }
      stub(addr).errors { address_errors }
    end
  end

  let (:date) { Date.parse('2013-10-02')}

  let(:order) do
    Object.new.tap do |order|
      stub(order).errors { order_errors }
      stub(order).address { address }
      stub(order).expected_date { date }
    end
  end

  let(:validator) {OrderCustomizedRegionValidator.new }

  it "passed the validation when no region rules are fetched" do
    stub(validator).fetch_policy { [] }
    dont_allow(order_errors).add.with_any_args
    validator.validate(order)
  end

  it "passed the validation when all region rules are passed" do
    stub(validator).fetch_policy { [valid_policy, valid_policy] }
    dont_allow(order_errors).add.with_any_args
    validator.validate(order)
  end

  it "add errors to order when any of the policies is not open" do
    stub(validator).fetch_policy { [valid_policy, not_open_policy] }
    mock(order_errors).add(:expected_date, :service_not_available)
    validator.validate(order)
  end

  it "add errors to order when any of the rules failed against the order address" do
    stub(validator).fetch_policy { [valid_policy, invalid_policy] }
    mock(order_errors).add(:expected_date)
    mock(address_errors).add(:province_id, :unavailable_location_at_date, date: date)
    mock(address_errors).add(:city_id)
    mock(address_errors).add(:area_id)
    validator.validate(order)
  end
end
