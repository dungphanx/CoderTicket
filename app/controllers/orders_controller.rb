class OrdersController < ApplicationController
	def new
		@event = Event.find(params[:event_id])
		@order = Order.new
		@event.ticket_types.each do |ticket_type|
      order_detail = @order.order_details.build
      order_detail.ticket_type = ticket_type
      order_detail.quantity = 0
      order_detail.price = ticket_type.price
      order_detail.total_price = 0
    end
	end

	def create
		@order = Order.new order_params
		@order.price = 0
		@order.order_details.each_with_index do |od, index|
			ticket_type = TicketType.find(od.ticket_type_id)
			od.price = ticket_type.price
			od.total_price = od.price * od.quantity
			@order.price += od.total_price
		end
		if @order.save
			flash[:success] = "Order success!"
			redirect_to event_order_path(params[:event_id].to_i, @order)
		else
			flash[:error] = "Error #{@order.errors.full_messages.to_sentence}"
			redirect_to :back
		end
	end

	def show
		@event = Event.find(params[:event_id])
		@order = Order.find(params[:id])
	end

	private
	def order_params
		params.require(:order).permit(:name, :address, :phone, :email, :price, order_details_attributes: [:ticket_type_id, :quantity, :price])
	end
end
