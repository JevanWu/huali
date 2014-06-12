module Erp
  class OrderEntry < ErpDatabase
    self.table_name = 'lysoorderentry'
    self.primary_key = "FID"

    coerce_sqlserver_date :FExpectedDate

    validates :FNumber, :FQty, :FTaxPrice, :FTaxAmount, :FTaxRate, :FExpectedDate,
      :FInterID, :FDiscount, presence: true

    validates :FQty, numericality: { only_integer: true, greater_than: 0 }
    validates :FTaxPrice, :FTaxAmount, :FTaxRate, :FDiscount,
      numericality: { greater_than: 0 }
  end
end
