class FollowRepository
  def followers(user_id)
    Follow.where(followee_id: user_id).map(&:follower)
  end

  def followees(user_id)
    Follow.where(follower_id: user_id).map(&:followee)
  end
end
