class Event < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :venue, class_name: 'Venue'
  belongs_to :category, class_name: 'Category'
  has_many :ticket_types

  validates_presence_of :extended_html_description, :venue, :category, :starts_at
  validates_uniqueness_of :name, uniqueness: {scope: [:venue, :starts_at]}


  def venue_name
  	venue.try(:name)
  end

  scope :upcoming_event, -> {where("events.starts_at > ? AND events.status = true", Time.zone.now.beginning_of_day)}

  def self.search(search)
  	if search && !search.empty?
  		where("name like ? and starts_at > ? AND status = true", "%#{search}%", Time.zone.now.beginning_of_day).order("starts_at")
  	else
  		where("starts_at > ? AND status = true", Time.zone.now.beginning_of_day).order("starts_at")
  	end
  end
end
