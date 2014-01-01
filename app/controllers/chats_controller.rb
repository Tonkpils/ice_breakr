class ChatsController < ApplicationController
  def index
    @user = current_user
    @users = current_user.chat_zone.users
  end

  def private_chat
    @user = User.find(params[:user_id])
    session[:chat_zone_id] = "#{current_user.chat_zone.id}"
    session[:user_id] = current_user.id
    session[:username] = current_user.username
  end
end