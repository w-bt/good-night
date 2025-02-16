class UserRepository
  def all
    User.all
  end

  def find(id)
    User.find(id)
  end
end
