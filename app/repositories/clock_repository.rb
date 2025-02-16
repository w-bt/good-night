class ClockRepository
  def initialize(user)
    @user = user
  end

  def find_active_clock
    @user.clocks.find_by(clock_out: nil)
  end

  def create_clock(clock_in: nil, clock_out: nil)
    @user.clocks.create(clock_in: clock_in, clock_out: clock_out)
  end
end
