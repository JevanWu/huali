module Erp
  class SeorderEntry < ErpDatabase
    self.table_name = "SEOrderEntry"
    self.primary_key = "FDetailID"

    belongs_to :seorder, foreign_key: 'FInterID'
  end
end
