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

  def create_user(attributes)
    @repository.create(attributes)
  end

  def update_user(user, attributes)
    @repository.update(user, attributes)
  end

  def delete_user(user)
    @repository.delete(user)
  end
end
