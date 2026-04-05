class UsersController < ApplicationController
  before_action :require_login, only: %i[show edit update]
  before_action :set_user, only: %i[show edit update]
  before_action :authorize_user_access!, only: %i[show edit update]

  def new
    @user = User.new
    @user.build_user_profile
  end

  def create
    @user = User.new(user_params.merge(role: :member, status: :active))

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully."
    else
      @user.build_user_profile unless @user.user_profile
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
    @user.build_user_profile unless @user.user_profile
  end

  def update
    if @user.update(user_update_params)
      redirect_to user_path(@user), notice: "Profile updated."
    else
      @user.build_user_profile unless @user.user_profile
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user_access!
    return if current_user.admin? || current_user == @user

    redirect_to root_path, alert: "You are not authorized to access this page."
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 user_profile_attributes: %i[full_name phone address])
  end

  def user_update_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 user_profile_attributes: %i[id full_name phone address])
  end
end

