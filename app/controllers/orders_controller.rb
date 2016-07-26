class OrdersController < ApplicationController
	def new
		@event = Event.find(params[:event_id])
		if @event.ends_at < Time.now
			flash[:error] = "You can't buy ticket with event in the past"
			redirect_to root_path
		else
			@order = Order.new
			@event.ticket_types.each do |ticket_type|
	      order_detail = @order.order_details.build
	      order_detail.ticket_type = ticket_type
	      order_detail.quantity = 0
	      order_detail.price = ticket_type.price
	      order_detail.total_price = 0
	    end
    end
	end

	def create
		@order = Order.new order_params
		@order.price = 0
		out_stock = false
		total_quantity = 0
		@order.order_details.each_with_index do |od, index|
			ticket_type = TicketType.find(od.ticket_type_id)
			if od.quantity < 1
				od.destroy
			else
			od.price = ticket_type.price
			od.total_price = od.price * od.quantity
			@order.price += od.total_price
			out_stock = true if od.quantity > ticket_type.max_quantity
			total_quantity += od.quantity
			end
		end
		
		if out_stock || total_quantity < 1
			flash[:error] = "Sorry, please check your quantity of ticket type and try again."
			redirect_to :back
		elsif total_quantity > 10
			flash[:error] = "Ops!,You just can buy maximum with 10 ticket!"
			redirect_to :back
		else
			if @order.save
				@order.order_details.each do |od|
					ticket_type = TicketType.find(od.ticket_type_id)
					ticket_type.max_quantity = ticket_type.max_quantity - od.quantity
					ticket_type.save
				end
				flash[:success] = "Order success!"
				redirect_to event_order_path(params[:event_id].to_i, @order)
			else
				flash[:error] = "Error #{@order.errors.full_messages.to_sentence}"
				redirect_to :back
			end
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
