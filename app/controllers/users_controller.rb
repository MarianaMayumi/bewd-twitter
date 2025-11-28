class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.new(user_params)

    if user.save
      render json: { message: "User created", user_id: user.id }
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
