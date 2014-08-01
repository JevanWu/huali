module Erp
  class Seorder < ErpDatabase
    self.table_name = "SEOrder"
    self.primary_key = "FInterID"

    has_many  :seorder_entries, foreign_key: 'FInterID'

    def self.update_shipment(order_identifier, shipment_info)
      seorder = self.find_by_FBillNo(order_identifier)

      seorder and shipment_info and seorder.update_column(:FHeadSelfS0155, shipment_info)
    end
  end
end
