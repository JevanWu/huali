module Erp
  class OrderEntry < ErpDatabase
    self.table_name = 'lysoorderentry'
    self.primary_key = "FID"
  end
end
