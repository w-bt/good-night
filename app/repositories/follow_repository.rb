class FollowRepository
  def followers(user_id)
    Follow.where(followee_id: user_id).map(&:follower)
  end
end
