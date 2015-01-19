module Erp
  class OrderImporter
    def initialize(order)
      @order = order
    end

    def import
      return if Erp::Seorder.where(FBillNo: @order.identifier).exists?

      Erp::Order.where(FBillNo: @order.identifier).destroy_all
      @erp_order = Erp::Order.from_order(@order)

      if @erp_order.persisted?
        validate_in_erp
        import_to_erp
      else
        raise ArgumentError, "ERP Validation errors: #{@order.identifier} #{@erp_order.errors.full_messages}"
      end
    end

  private

    def validate_in_erp
      result = Erp::Order.execute_procedure :validate_order, FBillNo: @order.identifier

      unless result.first['FError'] == 0
        raise ArgumentError, "ERP OrderValidation failed: #{@order.identifier}"
      end
    end

    def import_to_erp
      begin
        Erp::Order.execute_procedure :import_order, FBillNo: @order.identifier
      rescue
        raise ArgumentError, "ERP OrderImport failed: #{@order.identifier}"
      end
    end
  end
end
