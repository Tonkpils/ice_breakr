class ChatsController < ApplicationController
  def index
    @user = current_user
    @users = current_user.chat_zone.users
  end

  def private_chat
    @user = User.find(params[:user_id])
    session[:chat_zone_id] = "#{current_user.id}.#{@user.id}.#{current_user.chat_zone.id}"
  end
end