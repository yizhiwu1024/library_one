class SessionsController < ApplicationController
  def new
    return redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)

    if user&.authenticate(params[:password])
      if user.suspended?
        redirect_to login_path, alert: "Your account is suspended."
      else
        session[:user_id] = user.id
        redirect_to(root_path, notice: "Signed in successfully.")
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Signed out successfully."
  end
end

