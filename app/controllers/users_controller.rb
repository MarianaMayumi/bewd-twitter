class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.create(
      username: params[:user][:username],
      email: params[:user][:email],
      password: params[:user][:password]
    )

    render json: {
      user: {
        username: user.username,
        email: user.email
      }
    }
  end
end
