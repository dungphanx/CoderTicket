class Order < ActiveRecord::Base
  belongs_to :event
  has_many :order_details

  validates_presence_of :name, :email, :phone
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create, message: "format is not correct" }

  accepts_nested_attributes_for :order_details
end
