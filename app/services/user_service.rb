class UserService
  def initialize
    @repository = UserRepository.new
  end

  def all_users
    @repository.all
  end
end
