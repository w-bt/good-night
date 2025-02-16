class FolloweesClockWeeklyService
  def initialize(user, date)
    @user = user
    @date = date
  end

  def call
    Followees::FolloweesClockWeekly.new(@user, @date).call
  end
end
