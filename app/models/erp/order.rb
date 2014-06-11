module Erp
  class Order < ErpDatabase
    self.table_name = "lysoorder"
    self.primary_key = "FInterID"

    has_many :order_entries, foreign_key: 'FInterID', primary_key: 'FID'
    coerce_sqlserver_date :FDate
  end
end
