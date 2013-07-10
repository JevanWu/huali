# == Schema Information
#
# Table name: settings
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  thing_id   :integer
#  thing_type :string(30)
#  updated_at :datetime         not null
#  value      :text
#  var        :string(255)      not null
#
# Indexes
#
#  index_settings_on_thing_type_and_thing_id_and_var  (thing_type,thing_id,var) UNIQUE
#

class Setting < RailsSettings::CachedSettings
  attr_accessible :var, :value
end
