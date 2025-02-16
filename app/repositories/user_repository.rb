class UserRepository
  def all
    User.all
  end

  def find(id)
    Redis::User.new(id).get
  end

  def create(attributes)
    User.create(attributes)
  end

  def update(user, attributes)
    user.update(attributes)
    Redis::User.new(user.id).del
  end

  def delete(user)
    user.destroy
    Redis::User.new(user.id).del
  end
end
