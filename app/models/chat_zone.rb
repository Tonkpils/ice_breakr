class ChatZone < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude

  has_many :users

  BOUND = 10
end
