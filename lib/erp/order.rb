module Erp
  CLIENT_CODES = {
    normal: '01.01.0001',
    tmall: '01.01.0002',
    taobao: '01.01.0003',
    ctrip: '01.02.0031',
    jd: '01.01.0004',
    yhd: '01.01.0006',
    offline: '01.03',
    amazon: '01.01.0045'
  }

  CTRIP_COUPON_CHARGES = {
    # [*coupon_id] => Charging price
    89 => 220,
    157 => 220,
    91 => 400,
    90 => 800,
    178 => 400,
    186 => 220
  }

  TAX_RATE = 0.17

  class Order < ErpDatabase
    self.table_name = "lysoorder"
    self.primary_key = "FInterID"

    has_many :order_entries, foreign_key: 'FInterID', primary_key: 'FInterID', dependent: :destroy
    coerce_sqlserver_date :FDate

    validates :FOrg, :FDate, :FBillNo, :FInterID, presence: true
    validates :FBillNo, uniqueness: true

    extend Enumerize
    enumerize :FOrg, in: CLIENT_CODES.values, default: CLIENT_CODES.values.first

    def self.from_order(order)
      transaction = order.transactions.find { |t| t.state == 'completed' }
      shipment = order.shipments.find { |t| ["shipped", "completed"].include?(t.state) }

      ret = new(FOrg: order_org(order),
                FDate: order.created_at.to_date,
                FBillNo: order.identifier,
                FNote: order.memo,
                FInterID: order.id,
                FTransNo: transaction.try(:merchant_trade_no),
                FTransType: trans_type(transaction),
                FTransFee: transaction.try(:commission_fee),
                FShipment: shipment && "#{shipment.ship_method}: #{shipment.tracking_num}")

      order.line_items.each do |item|
        ret.order_entries.build(FNumber: item.sku_id,
                                FQty: item.quantity,
                                FTaxPrice: item.price,
                                FTaxAmount: item.total,
                                FTaxRate: TAX_RATE,
                                FExpectedDate: order.delivery_date, # Import delivery_date instead of expected_date
                                FDiscount: discount_by_item(order, transaction, item))
      end

      ret.save
      ret
    end

    class << self

    private

      def order_org(order)
        if ctrip_order_charge(order) > 0
          CLIENT_CODES[:ctrip]
        else
          CLIENT_CODES[order.kind.to_sym]
        end
      end

      def trans_type(transaction)
        return '*' if transaction.nil?

        case transaction.paymethod
        when 'pos'
          '05'
        when 'cash'
          '04'
        when 'paypal'
          '03'
        when 'wechat'
          '02'
        else
          '01'
        end
      end

      def discount_by_item(order, transaction, item)
        (item.total / order.item_total.to_f) * total_discount(order, transaction)
      end

      def total_discount(order, transaction)
        [order.item_total - ctrip_order_charge(order) - transaction.try(:amount).to_f , 0].max
      end

      def ctrip_order_charge(order)
        coupon_id = order.try(:coupon_code_record).try(:coupon_id)

        CTRIP_COUPON_CHARGES[coupon_id].to_f
      end
    end
  end
end
