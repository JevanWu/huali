class DistrictValidator < ActiveModel::Validator
  def validate(order)
    if !DistrictCheckService.new(order.address.city_id, order.address.address).inside?($inner_zone)
      order.errors.add(:base, :district_not_valid)
    end
  end
end

