class ClockRepository
  def initialize(user)
    @user = user
  end

  def find_active_clock
    @user.clocks.find_by(clock_out: nil)
  end
end
