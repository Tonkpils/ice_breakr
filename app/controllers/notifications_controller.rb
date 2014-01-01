class NotificationsController < ApplicationController
  include Tubesock::Hijack

  def chat
    hijack do |tubesock|
      redis_thread = Thread.new do

        # Subscribe each new connection to their chat zone.
        Redis.new.subscribe session[:chat_zone_id] do |on|
          message_event_block(tubesock, on)
          
          message = build_event "zoneuser_add"
          Redis.new.publish(session[:chat_zone_id], message)
        end

        # Subscribe each user to their own notification connection
        Redis.new.subscribe session[:user_id] do |on|
          message_event_block(tubesock, on)
        end

      end

      tubesock.onopen do
        # Redis.new.publish session[:chat_zone_id], "You are now chatting with someone..."
      end
      tubesock.onmessage do |m|
        Redis.new.publish session[:chat_zone_id], m
      end

      tubesock.onclose do
        message = build_event "zoneuser_remove"
        Redis.new.publish(session[:chat_zone_id], message)
        redis_thread.kill
      end

    end
  end
  private
    def message_event_block(tubesock, on)
      on.message do |channel, message|
        send_data(tubesock, channel, message)
      end
    end

    def send_data(tubesock, channel, message)
      client_data = { channel: channel, message: message }
      tubesock.send_data(client_data)
    end

    # Helper to create boilerplate data for an event to be emitted.
    def build_event event
      ({ event: event, data: { user: get_user } })
    end

    # Helper method to get current user data.
    def get_user
      user = { id: session[:user_id], username: session[:username] }
    end
end