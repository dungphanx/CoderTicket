class TicketType < ActiveRecord::Base
  belongs_to :event
  validates :name, :price, :max_quantity, presence: true
end
