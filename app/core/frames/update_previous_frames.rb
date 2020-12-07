# frozen_string_literal: true

module Frames
  class UpdatePreviousFrames
    attr_accessor :frame

    def initialize(frame)
      @frame = frame
    end

    def do_updates
      return if previous_frame.nil?
      return unless Frame::UNLOCK_BALL_THREE_TYPES.include?(previous_frame_type)

      update_spare if spare?
      update_strike if strike?
      update_double_strike if double_strike?
    end

    def update_spare
      _score = previous_frame.ball_one.to_i
      _score += previous_frame.ball_two.to_i
      _score += frame.ball_one.to_i
      previous_frame.update(score: _score)
    end

    def update_strike
      _score = previous_frame.ball_one.to_i
      _score += frame.ball_one.to_i
      _score += frame.ball_two.to_i
      previous_frame.update(score: _score)
    end

    def update_double_strike
      _score = previous_previous_frame.ball_one.to_i
      _score += previous_frame.ball_one.to_i
      _score += frame.ball_one.to_i
      previous_previous_frame.update(score: _score)
    end

    def previous_frame
      @previous_frame ||= frame.previous_frame
    end

    def previous_previous_frame
      @previous_previous_frame ||= previous_frame.try(:previous_frame)
    end

    def previous_frame_type
      @previous_frame_type ||= previous_frame.try(:frame_type)
    end

    def spare?
      previous_frame_type == 'spare'
    end

    def strike?
      previous_frame_type == 'strike'
    end

    def double_strike?
      return false unless strike?
      return false if previous_previous_frame.nil?

      previous_previous_frame.frame_type == 'strike'
    end
  end
end
