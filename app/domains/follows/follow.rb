module Follows
  class Follow
    attr_accessor :follower_id, :followee_id

    def initialize(attributes = {})
      @follower_id = attributes[:follower_id]
      @followee_id = attributes[:followee_id]
    end

    def valid?
      follower_id.present? && followee_id.present?
    end
  end
end
