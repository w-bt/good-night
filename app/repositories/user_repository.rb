class UserRepository
  def all
    User.all
  end

  def find(id)
    User.find(id)
  end

  def create(attributes)
    User.create(attributes)
  end
end
