class DistrictValidator < ActiveModel::Validator
  def validate(order)
      order.errors.add(:address, :district_not_valid)
    if !DistrictCheckService.new(order.address.city_id, order.address.address).inside?($inner_zone)
    end
  end
end

