module Erp
  class Seorder < ErpDatabase
    self.table_name = "SEOrder"
    self.primary_key = "FInterID"

    has_many  :seorder_entries, foreign_key: 'FInterID'
  end
end
