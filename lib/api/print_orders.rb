module API
  # Print orders API
  class PrintOrders < Grape::API
    DEFAULT_BATCH_SIZE = 5
    resource :printing do
      # Get order print queue by print group.
      #
      # Parameters:
      #   print_group (required)          - Print group name

      # Example Request:
      #   GET /printing/group1/orders/unprinted

      get ':print_group/orders/unprinted' do
        print_group = PrintGroup.find_by_name(params[:print_group])

        if params[:print_id].present?
          print_group.print_orders.query_by_delivery_date(params[:delivery_date].to_date || Date.tomorrow).query_by_product(params[:print_id]).where(order_printed: false).limit(params[:batch_size] || DEFAULT_BATCH_SIZE).map(&:order_id)
        else
          print_group.print_orders.query_by_delivery_date(params[:delivery_date].to_date || Date.tomorrow).where(order_printed: false).limit(params[:batch_size] || DEFAULT_BATCH_SIZE).map(&:order_id)
        end
      end

      # Get order card print queue by print group.
      #
      # Parameters:
      #   print_group (required)          - Print group name

      # Example Request:
      #   GET /printing/group1/order_cards/unprinted

      get ':print_group/order_cards/unprinted' do
        print_group = PrintGroup.find_by_name(params[:print_group])

        if params[:print_id].present?
          print_group.print_orders.query_by_delivery_date(params[:delivery_date].to_date || Date.tomorrow).query_by_product(params[:print_id]).where(card_printed: false).limit(params[:batch_size] || DEFAULT_BATCH_SIZE).map(&:order_id)
        else
          print_group.print_orders.query_by_delivery_date(params[:delivery_date].to_date || Date.tomorrow).where(card_printed: false).limit(params[:batch_size] || DEFAULT_BATCH_SIZE).map(&:order_id)
        end
      end

      # Get order shipment print queue by print group.
      #
      # Parameters:
      #   print_group (required)          - Print group name

      # Example Request:
      #   GET /printing/group1/order_shipments/unprinted

      get ':print_group/order_shipments/unprinted' do
        print_group = PrintGroup.find_by_name(params[:print_group])

        if params[:print_id].present?
          print_group.print_orders.query_by_delivery_date(params[:delivery_date].to_date || Date.tomorrow).query_by_product(params[:print_id]).where(shipment_printed: false).limit(params[:batch_size] || DEFAULT_BATCH_SIZE).map(&:order_id)
        else
          print_group.print_orders.query_by_delivery_date(params[:delivery_date].to_date || Date.tomorrow).where(shipment_printed: false).limit(params[:batch_size] || DEFAULT_BATCH_SIZE).map(&:order_id)
        end
      end

      # Update order print status.
      #
      # Parameters:
      #   order_ids (required)          - Order ids to set printed

      # Example Request:
      #   PUT /printing/orders/printed

      put 'orders/printed' do
        order_ids = params[:order_ids].split(',')

        unless order_ids.blank?
          PrintOrder.connection.execute("UPDATE print_orders SET order_printed = 't' WHERE order_id IN (#{order_ids.join(',')})")
        end

        status(200)
      end

      # Update order card print status.
      #
      # Parameters:
      #   order_ids (required)          - Order ids to set printed

      # Example Request:
      #   PUT /printing/order_cards/printed

      put 'order_cards/printed' do
        order_ids = params[:order_ids].split(',')

        unless order_ids.blank?
          PrintOrder.connection.execute("UPDATE print_orders SET card_printed = 't' WHERE order_id IN (#{order_ids.join(',')})")
        end

        status(200)
      end

      # Update order shipment print status.
      #
      # Parameters:
      #   order_ids (required)          - Order ids to set printed

      # Example Request:
      #   PUT /printing/order_shipments/printed

      put 'order_shipments/printed' do
        order_ids = params[:order_ids].split(',')

        unless order_ids.blank?
          PrintOrder.connection.execute("UPDATE print_orders SET shipment_printed = 't' WHERE order_id IN (#{order_ids.join(',')})")
        end

        status(200)
      end

    end
  end
end
