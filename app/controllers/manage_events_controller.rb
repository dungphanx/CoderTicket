class ManageEventsController < ApplicationController
	before_action :check_user
	def index
		@user = User.find(params[:user_id])
		@events = Event.where("owner_id = ?", @user.id)
	end

	def publish
		@event = Event.find_by("id = ? and owner_id = ?", params[:id].to_i, params[:user_id].to_i)
		@event.status = true
		if @event.ticket_types.count == 0
			flash[:error] = "This event haven't any ticket, please create first!"
			redirect_to user_manage_events_path(current_user)
		else
			if @event.save
				flash[:success] = "Event published"
				redirect_to root_path
			else
				flash[:error] = "Something went wrong!"
				redirect_to users_manage_events_path current_user
			end
		end
	end

	def edit
		@event = Event.find_by('owner_id = ? and id = ?', params[:user_id].to_i, params[:id].to_i)
		@categories = Category.all
		@venues = Venue.all
	end

	def update
		@event = Event.find_by('owner_id = ? and id = ?', params[:user_id].to_i, params[:id].to_i)
		if @event.update_attributes event_params
			flash[:success] = "Event updated"
			redirect_to root_path
		else
			flash[:error] = "Error #{@event.errors.full_messages.to_sentence}"
			render 'edit'
		end
	end

	private
	def check_user
		@user = User.find(params[:user_id])
		if @user != current_user
			redirect_to root_path
		end
	end

  def event_params
  	params.require(:event).permit(:starts_at, :ends_at, :venue_id, :hero_image_url, :extended_html_description, :category_id, :name, :user_id)
  end
end
