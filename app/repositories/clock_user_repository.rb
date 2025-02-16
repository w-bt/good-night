class ClockUserRepository
  def initialize(user)
    @user = user
  end

  def find_active_clock
    @user.clocks.find_by(clock_out: nil)
  end

  def create_clock(clock_in: nil, clock_out: nil)
    @user.clocks.create(clock_in: clock_in, clock_out: clock_out)
  end

  def update_clock(clock, clock_out: nil)
    clock.update(clock_out: clock_out)
    clock
  end

  def all_clocks
    @user.clocks
  end
end
