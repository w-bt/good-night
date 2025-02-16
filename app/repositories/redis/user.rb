# frozen_string_literal: true

class Redis::User < Redis::AbstractModels
  def initialize(user_id)
    @user_id = user_id
  end

  def get
    super
  end

  def del
    super
  end

  private

  def models
    ::User
  end

  def key
    "#{models.name}::#{@user_id}"
  end

  def expiry
    1.day
  end

  def attrs
    { id: @user_id }
  end
end
