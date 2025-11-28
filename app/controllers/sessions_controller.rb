class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_by(username: params[:user][:username])

    if user && user.password == params[:user][:password]
      session_record = Session.create(user: user)
      cookies.permanent[:twitter_session_token] = session_record.token

      render json: { message: "Logged in" }
    else
      render json: { message: "Invalid username or password" }, status: 401
    end
  end

  def authenticated
    session_record = Session.find_by(token: cookies[:twitter_session_token])

    if session_record
      render json: { authenticated: true, user_id: session_record.user_id }
    else
      render json: { authenticated: false }
    end
  end

  def destroy
    session_record = Session.find_by(token: cookies[:twitter_session_token])

    if session_record
      session_record.destroy
      render json: { message: "Logged out" }
    else
      render json: { message: "No session found" }, status: 404
    end
  end
end
