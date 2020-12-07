module Frames
  module Validators
    class AddPoints < ::Validators::Base
      include ::Validators::Shared::Points

      TOTAL_POINTS = 10
      attr_accessor :frame_id, :points
      validates :frame, presence: true
      validate :frame_validations

      def initialize(frame_id, points)
        @frame_id = frame_id
        @points = points
      end

      def frame
        @frame ||= Frame.find_by(id: frame_id)
      end

      def frame_validations
        return if frame.nil?
        return unless errors.count.zero?

        errors.add(:frame, 'Frame is closed') if frame.closed
        return if frame.last_frame?

        errors.add(:frame, 'After those points score will be invalid') if invalid_score?
      end

      private

      def invalid_score?
        frame.score.to_i + points.to_i > TOTAL_POINTS
      end
    end
  end
end