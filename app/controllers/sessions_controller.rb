class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /sessions
  def create
    username = params.dig(:user, :username)
    password = params.dig(:user, :password)

    user = User.find_by(username: username)

    if user && user.authenticate(password)
      session_record = user.sessions.create
      cookies.signed['twitter_session_token'] = session_record.token

      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  # GET /authenticated
  def authenticated
    token = cookies.signed['twitter_session_token']
    session_record = Session.find_by(token: token)

    if session_record
      render json: {
        authenticated: true,
        username: session_record.user.username
      }
    else
      render json: { authenticated: false }
    end
  end

  # DELETE /sessions
  def destroy
    token = cookies.signed['twitter_session_token']
    session_record = Session.find_by(token: token)

    if session_record
      session_record.user.sessions.destroy_all
      render json: { success: true }
    else
      render json: { success: false }
    end
  end
end

