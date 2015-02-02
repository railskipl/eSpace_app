class AccessId < ActiveRecord::Base
	validates_uniqueness_of :email, :message => " domain '%{value}' has already been taken."
end
