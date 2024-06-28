class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def add_friend
    friend = User.find(params[:id])
    current_user.friendships.create(friend: friend)
    # friend.friendships.create(friend: current_user)
    redirect_back(fallback_location: users_path)
  end

  def remove_friend
    friendship = current_user.friendships.find_by(friend_id: params[:id])
    inverse_friendship = User.find_by(id: params[:id]).friendships.find_by(friend_id: current_user.id)
    friendship.destroy
    inverse_friendship.destroy

    current_user_id = current_user.id
    other_user_id = params[:id].to_i

    friend_requests = FriendRequest.where(
      "(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
      current_user_id, other_user_id, other_user_id, current_user_id
    )

    friend_requests.destroy_all
    redirect_back(fallback_location: users_path)
  end

  def friends
    @friends = current_user.friends
  end

  private

  def set_friendships_params
    # params.require(:friend).permit(:id)
  end

end