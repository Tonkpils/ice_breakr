class NotificationsController < ApplicationController
  include Tubesock::Hijack

  def chat
    hijack do |tubesock|
      redis_thread = Thread.new do

        message = build_event "zoneuser_add"
        message = message.to_json
        Redis.new.publish session[:chat_zone_id], message

        # Subscribe each new connection to their chat zone.
        Redis.new.subscribe session[:chat_zone_id] do |on|
          message_event_block(tubesock, on)
        end

        # Subscribe each user to their own notification connection
        Redis.new.subscribe session[:user_id] do |on|
          message_event_block(tubesock, on)
        end

      end

      tubesock.onopen do

      end
      tubesock.onmessage do |data|
        route_message data
        # Redis.new.publish session[:chat_zone_id], m
      end

      tubesock.onclose do
        message = build_event "zoneuser_remove"
        message = message.to_json
        Redis.new.publish(session[:chat_zone_id], message)
        redis_thread.kill
      end

    end
  end
  private
    def route_message(m)
      data = JSON.parse m
      # Handle each event type
      if data['event'] == 'send_message'
        data = data.merge get_user
        message = data.to_json
        # Send message to each recipient
        data['recipients'].each { |user_id|
          Redis.new.publish(user_id, message)
        }
      end
    end

    def message_event_block(tubesock, on)
      on.message do |channel, message|
        send_data(tubesock, channel, message)
      end
    end

    def send_data(tubesock, channel, message)
      tubesock.send_data(message)
    end

    # Helper to create boilerplate data for an event to be emitted.
    def build_event event
      ({ :event => event}.merge(get_user))
    end

    # Helper method to get current user data.
    def get_user
      user = { :id => session[:user_id], :event_user => session[:username] }
    end
end