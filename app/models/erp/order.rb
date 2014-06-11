module Erp
  CLIENT_CODES = {
    normal: '01.01.0001',
    tmall: '01.01.0002',
    taobao: '01.01.0003'
  }

  class Order < ErpDatabase
    self.table_name = "lysoorder"
    self.primary_key = "FInterID"

    has_many :order_entries, foreign_key: 'FInterID', primary_key: 'FID'
    coerce_sqlserver_date :FDate
  end
end
