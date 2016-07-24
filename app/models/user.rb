class User < ActiveRecord::Base
	validates :name, presence: true
	validates :email, presence: true, uniqueness: {case_insensitive: false}
	has_secure_password
	has_many :event
end
