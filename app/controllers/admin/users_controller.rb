module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[show edit update]

    def index
      @users = User.includes(:user_profile).order(:email)
    end

    def show; end

    def edit
      @user.build_user_profile unless @user.user_profile
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "User updated successfully."
      else
        @user.build_user_profile unless @user.user_profile
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :role, :status,
                                   user_profile_attributes: %i[id full_name phone address])
    end
  end
end

