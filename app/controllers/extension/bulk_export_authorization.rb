module Extension
  module BulkExportAuthorization
    extend ActiveSupport::Concern

    included do
      before_action :authorize_to_bulk_export_data
    end

    private

    def authorize_to_bulk_export_data
      current_admin_ability.authorize! :bulk_export_data, :all if bulk_export_request?
    end

    def bulk_export_request?
      self.class.to_s =~ /^Admin::/ && params[:format] != nil
    end
  end
end

