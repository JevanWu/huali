require 'csv'

module RegionRuleHelper
  def import_region_data_from_files
    region_data = File.expand_path('../../fixtures/regions.sql', __FILE__)

    ActiveRecord::Base.connection.execute(File.read(region_data))
  end

  def check_and_open_child(region)
    check region
    find('label', text: region).first(:xpath,".//..").find_button('+').click
  end
end
