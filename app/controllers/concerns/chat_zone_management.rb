module Concerns
  module ChatZoneManagement
    extend ActiveSupport::Concern

    def assign_chat_zone(user)
      location = params[:location]
      chat_zone = ChatZone.near([location[:latitude], location[:longitude]], ChatZone::BOUND).first_or_create(location_params)
      user.chat_zone = chat_zone
    end

    def location_params
      params.require(:location).permit(:latitude, :longitude)
    end

  end
end