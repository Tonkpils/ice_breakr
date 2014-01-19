class NotificationsController < ApplicationController
  include Tubesock::Hijack

  def chat
    hijack do |tubesock|

      @redis = Redis.new(host: REDIS_URI.host, port: REDIS_URI.port, password: REDIS_URI.password)

      redis_thread = Thread.new do
        redis_sub = Redis.new(host: REDIS_URI.host, port: REDIS_URI.port, password: REDIS_URI.password)
        # TODO - Create a session id unique to each user in a chat zone in order to message them directly
        redis_sub.subscribe session[:chat_zone_id] do |on|
          on.message do |channel, message|
             tubesock.send_data message
          end
        end
      end

      tubesock.onopen do
        @redis.publish session[:chat_zone_id], "You are now chatting with someone...#{session[:chat_zone_id]}"
      end
      tubesock.onmessage do |message|
        @redis.publish session[:chat_zone_id], message
      end

      tubesock.onclose do
        redis_thread.kill
      end

    end

  end

end
