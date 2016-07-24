class EventsController < ApplicationController
  def index
    @events = Event.search(params[:name]) #upcoming_event
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
  	@venues = Venue.all
  	@categorys = Category.all
  	@event = Event.new
  end

  def create
  	@event = Event.new event_params
  	@event.owner_id = current_user.id
  	@event.status = false
  	if @event.save
  		redirect_to user_manage_events_path(current_user)
  	else
  		flash[:error] = "Error: #{@event.errors.full_messages.to_sentence}"
  		redirect_to new_event_path
  	end
  end

  private
  def event_params
  	params.require(:event).permit(:starts_at, :ends_at, :venue_id, :hero_image_url, :extended_html_description, :category_id, :name, :user_id)
  end
end
