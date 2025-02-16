# app/services/clock_service.rb
class ClockService
  def initialize(user)
    @user = user
    @repository = ClockRepository.new(user)
  end

  def clock_in
    active_clock = @repository.find_active_clock
    return { error: "Already clocked in" } if active_clock

    clock = @repository.create_clock(clock_in: Time.current)
    { success: "Clocked in successfully", clock: clock }
  end
end
