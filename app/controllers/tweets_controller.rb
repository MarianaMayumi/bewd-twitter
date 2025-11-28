class TweetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = current_user
    return render json: { message: "Not authenticated" }, status: 401 unless user

    tweet = user.tweets.new(tweet_params)

    if tweet.save
      render json: { message: "Tweet created" }
    else
      render json: { errors: tweet.errors.full_messages }, status: 422
    end
  end

  def destroy
    user = current_user
    return render json: { message: "Not authenticated" }, status: 401 unless user

    tweet = user.tweets.find_by(id: params[:id])

    if tweet
      tweet.destroy
      render json: { message: "Tweet deleted" }
    else
      render json: { message: "Tweet not found" }, status: 404
    end
  end

  def index
    @tweets = Tweet.includes(:user).order(created_at: :desc)
  end

  def index_by_user
    user = User.find_by(username: params[:username])

    if user
      @tweets = user.tweets.includes(:user).order(created_at: :desc)
      render :index
    else
      render json: { message: "User not found" }, status: 404
    end
  end

  private

  def current_user
    session_record = Session.find_by(token: cookies[:twitter_session_token])
    session_record&.user
  end

  def tweet_params
    params.require(:tweet).permit(:message)
  end
end
