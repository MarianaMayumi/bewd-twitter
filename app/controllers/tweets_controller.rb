class TweetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /tweets
  def create
    token = cookies.signed['twitter_session_token']
    session_record = Session.find_by(token: token)

    return render json: { success: false } unless session_record

    tweet = session_record.user.tweets.create(message: params[:tweet][:message])

    render json: {
      tweet: {
        username: session_record.user.username,
        message: tweet.message
      }
    }
  end

  # GET /tweets
  def index
    tweets = Tweet.includes(:user).order(created_at: :desc)

    render json: {
      tweets: tweets.map do |t|
        {
          id: t.id,
          username: t.user.username,
          message: t.message
        }
      end
    }
  end

  # DELETE /tweets/:id
  def destroy
    token = cookies.signed['twitter_session_token']
    session_record = Session.find_by(token: token)

    return render json: { success: false } unless session_record

    tweet = Tweet.find_by(id: params[:id])

    if tweet && tweet.user_id == session_record.user_id
      tweet.destroy
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  # GET /users/:username/tweets
  def index_by_user
    user = User.find_by(username: params[:username])
    tweets = user ? user.tweets.order(created_at: :desc) : []

    render json: {
      tweets: tweets.map do |t|
        {
          id: t.id,
          username: t.user.username,
          message: t.message
        }
      end
    }
  end
end
