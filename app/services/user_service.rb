class UserService
  def initialize
    @repository = UserRepository.new
  end

  def all_users
    @repository.all
  end

  def find_user(id)
    @repository.find(id)
  end
end
