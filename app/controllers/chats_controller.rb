class ChatsController < ApplicationController
  def index
    @users = current_user.chat_zone.users
  end

  def private_chat
    @user = User.find(params[:user_id])
    session[:chatroom_id] = "#{current_user.id}.#{@user.id}.#{current_user.chat_zone.id}"
  end
end