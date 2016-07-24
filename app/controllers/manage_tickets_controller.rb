class ManageTicketsController < ApplicationController
	def new
		@event = Event.find_by("id = ? and owner_id = ?", params[:manage_event_id].to_i, params[:user_id].to_i)
		@ticket = TicketType.new
	end

	def create
		@event = Event.find_by("id = ? and owner_id = ?", params[:manage_event_id].to_i, params[:user_id].to_i)
		@ticket = TicketType.new ticket_params
		@ticket.event_id = params[:manage_event_id].to_i

		if @ticket.save
			flash[:success] = "Ticket created!"
			redirect_to @event
		else
			flash[:error] = "Error #{@ticket.errors.full_messages.to_sentence}"
			redirect_to new_user_manage_event_manage_ticket_path(params[:user_id], params[:manage_event_id])
		end
	end

	private
	def ticket_params
		params.require(:ticket_type).permit(:price, :name, :max_quantity)
	end
end
