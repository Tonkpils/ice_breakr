class NotificationsController < ApplicationController
  include Tubesock::Hijack

  def chat
    hijack do |tubesock|
      redis_thread = Thread.new do
        # TODO - Create a session id unique to each user in a chat zone in order to message them directly
        Redis.new.subscribe session[:chatroom_id] do |on|
          on.message do |channel, message|
             tubesock.send_data message
          end
        end
      end

      tubesock.onopen do
        Redis.new.publish session[:chatroom_id], "You are now chatting with someone..."
      end
      tubesock.onmessage do |m|
        Redis.new.publish session[:chatroom_id], m
      end

      tubesock.onclose do
        redis_thread.kill
      end

    end

  end

end