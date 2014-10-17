class MigrateDataFromProductDescription < ActiveRecord::Migration
  def change
    Product.all.each do |product|
      records = product.description.split("###")
      records.each do |record|
        if record.include? "花艺师手记"
          next if record.match(/inspiration(.*)/mi).nil?
          content = record.match(/inspiration(.*)/mi)[1].gsub("</span>", "")
          product.update_column(:inspiration, content)
          next
        elsif record.include? "用材介绍"
          next if record.match(/material(.*)/mi).nil?
          content = record.match(/material(.*)/mi)[1].gsub("</span>", "")
          product.update_column(:material, content)
          next
        elsif record.include? "养护说明"
          next if record.match(/maintenance(.*)/mi).nil?
          content = record.match(/maintenance(.*)/mi)[1].gsub("</span>", "")
          product.update_column(:maintenance, content)
          next
        elsif record.include? "保养说明"
          next if record.match(/care(.*)/mi).nil?
          content = record.match(/care(.*)/mi)[1].gsub("</span>", "")
          product.update_column(:maintenance, content)
          next
        elsif record.include? "运输说明"
          next if record.match(/delivery(.*)/mi).nil?
          content = record.match(/delivery(.*)/mi)[1].gsub("</span>", "")
          product.update_column(:delivery, content)
          next
        end
      end
    end
  end
end
