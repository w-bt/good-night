class FollowService
  def initialize
    @repository = FollowRepository.new
  end

  def followers(user_id)
    @repository.followers(user_id)
  end
end
