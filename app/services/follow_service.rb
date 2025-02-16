class FollowService
  def initialize
    @repository = FollowRepository.new
  end

  def followers(user_id)
    @repository.followers(user_id)
  end

  def followees(user_id)
    @repository.followees(user_id)
  end

  def find_follow_by_users(follower_id, followee_id)
    @repository.find_follow_by_users(follower_id, followee_id)
  end

  def create_follow(attributes)
    follow = Follows::Follow.new(attributes)
    if follow.valid?
      @repository.create(attributes)
    else
      false
    end
  end
end
