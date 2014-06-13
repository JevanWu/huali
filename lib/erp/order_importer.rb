module Erp
  class OrderImporter
    def initialize(order)
      @order = order
    end

    def import
      @erp_order = Erp::Order.from_order(@order)

      if @erp_order.persisted?
        validate_in_erp and import_to_erp and return true
      else
        logger.error("ERP Validation errors: #{@erp_order.errors.full_messages}")
        false
      end
    end

  private

    def validate_in_erp
      result = Erp::Order.execute_procedure :validate_order, FBillNo: @order.identifier

      return true if result.blank?

      @erp_order.destroy
      logger.error("ERP OrderValidation failed: #{@order.identifier}")

      false
    end

    def import_to_erp
      Erp::Order.execute_procedure :import_order, FBillNo: @order.identifier
    end

    def logger
      @logger ||= Logger.new("#{Rails.root}/log/erp.log")
    end
  end
end
