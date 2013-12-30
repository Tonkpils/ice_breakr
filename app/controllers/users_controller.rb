class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  include Concerns::ChatZoneManagement

  # GET /users
  # GET /users.json
  def index
    @users = current_user.chat_zone.users.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /login
  # POST /login
  def login
    if request.method == 'POST'
      @user = User.find_by username: params[:username]
      if @user
        update_session_user
      else
        @errors = ['Unable to find account for ' << params[:username]]
      end
    end

    if valid_session
      redirect_to chat_path
    end
  end

  #GET /logout
  def logout
    destroy_session
    redirect_to action: 'login'
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    assign_chat_zone(@user)

    respond_to do |format|
      if @user.save
        update_session_user

        format.html { redirect_to chat_path, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username)
    end

    def update_session_user
      session[:current_user_id] = @user.id
    end

    def valid_session
      if session[:current_user_id]
        user = User.find session[:current_user_id]      
      end
    end

    def destroy_session
      session[:current_user_id] = nil
    end
end
