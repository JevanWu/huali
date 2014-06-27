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
        logger.error("ERP Validation errors: #{@order.identifier} #{@erp_order.errors.full_messages}")
        false
      end
    end

  private

    def validate_in_erp
      result = Erp::Order.execute_procedure :validate_order, FBillNo: @order.identifier

      error_code = result.first['FError']
      return true if error_code == 0

      @erp_order.destroy
      logger.error("ERP OrderValidation failed: #{@order.identifier}")

      false
    end

    def import_to_erp
      begin
        Erp::Order.execute_procedure :import_order, FBillNo: @order.identifier
      rescue ActiveRecord::StatementInvalid => e
        @erp_order.destroy
        logger.error("ERP OrderImport failed: #{@order.identifier}")
        false
      end
    end

    def logger
      @logger ||= Logger.new("#{Rails.root}/log/erp.log")
    end
  end
end
