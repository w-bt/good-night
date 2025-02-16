module Followees
  class FolloweesClockDaily
    BATCH_SIZE = 10
    public_constant :BATCH_SIZE

    def initialize(user, date)
      @user = user
      @date = date
      @follow_repository = FollowRepository.new
      @clock_daily_repository = ClockDailyRepository.new
    end

    def call
      followee_clocks = []

      @follow_repository.find_followee_ids_in_batches(@user.id, batch_size: BATCH_SIZE) do |followee_ids|
        clock_dailies = @clock_daily_repository.find_by_users_and_date(followee_ids, @date)

        followee_ids.each do |id|
          followee_clocks << { user_id: id, clock_daily: clock_dailies[id]&.first }
        end
      end

      # Sort followee clocks by total_duration in descending order (nil values last)
      followee_clocks.sort_by! { |entry| -(entry[:clock_daily]&.[](:total_duration) || 0) }

      followee_clocks
    end
  end
end
