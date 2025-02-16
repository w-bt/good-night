class FolloweesClockDailyService
  def initialize(user, date)
    @user = user
    @date = date
  end

  def call
    Followees::FolloweesClockDaily.new(@user, @date).call
  end
end
