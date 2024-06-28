class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create_friend_request
    receiver = User.find(params[:id])
    current_user.send_friend_request(receiver)
    redirect_back(fallback_location: users_path)
  end

  def accept
    sender = User.find(params[:id])
    current_user.accept_friend_request(sender)
    redirect_back(fallback_location: users_path)
  end

  def reject
    sender = User.find(params[:id])
    current_user.reject_friend_request(sender)
    redirect_back(fallback_location: users_path)
  end

  def friend_requests
    @send_requests = current_user.sent_friend_requests.where(status: 'pending').page(params[:page]).per(10)
    @received_requests = current_user.received_friend_requests.where(status: 'pending').page(params[:page]).per(10)
  end

  def remove_friend_request
    receiver = User.find(params[:id])
    current_user.remove_friend_request(receiver)
    redirect_back(fallback_location: users_path)
  end

end
