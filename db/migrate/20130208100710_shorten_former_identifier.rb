class Order < ActiveRecord::Base
end

class Transaction < ActiveRecord::Base
end

class Shipment < ActiveRecord::Base
end

class ShortenFormerIdentifier < ActiveRecord::Migration
  def up
    Order.find_each do |o|
      modify_identifier o
    end

    Transaction.find_each do |t|
      modify_identifier t
    end

    Shipment.find_each do |s|
      modify_identifier s
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

def modify_identifier(record)
  record.identifier = record.identifier.gsub(/20(\d\d)(\d\d\d\d)00(\d\d\d\d)/, '\1\2\3')
  record.save
  puts "#{record} identifier is changed to #{record.identifier}"
end
