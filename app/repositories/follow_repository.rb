class FollowRepository
  def followers(user_id)
    Follow.where(followee_id: user_id).map(&:follower)
  end

  def followees(user_id)
    Follow.where(follower_id: user_id).map(&:followee)
  end

  def find_follow_by_users(follower_id, followee_id)
    Follow.find_by(follower_id: follower_id, followee_id: followee_id)
  end

  def create(attributes)
    Follow.create(attributes)
  end

  def delete(follow)
    follow.destroy
  end
end
