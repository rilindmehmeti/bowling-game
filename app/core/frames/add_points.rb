# frozen_string_literal: true

module Frames
  class AddPoints
    attr_accessor :frame_id, :points, :validator
    def initialize(frame_id, points)
      @frame_id = frame_id
      @points = points
      @validator = Frames::Validators::AddPoints.new(frame_id, points)
    end

    def frame
      @frame ||= Frame.find(frame_id)
    end

    def valid?
      @valid ||= validator.valid?
    end

    def errors
      @errors ||= validator.errors
    end

    def add_points
      raise Exceptions::InvalidInput, errors.full_messages unless valid?

      add_frame_points
    end

    private

    def add_frame_points
      ball_field = frame.current_ball
      if ball_field.nil?
        raise Exceptions::InvalidBallField, 'No more balls allowed in this frame'
      end

      save_frame_score(ball_field)
      check_for_strike(ball_field)
      check_for_spare(ball_field)
      close_frame if should_close?(ball_field)
      return if frame.previous_frame.nil?

      UpdatePreviousFrames.new(frame).do_updates
    end

    def save_frame_score(ball_field)
      frame.send("#{ball_field}=", points)
      frame.score = frame.score + points
      frame.save
    end

    def check_for_strike(ball_field)
      return unless ball_field == :ball_one
      return if points != 10

      frame.update(frame_type: :strike)
    end

    def check_for_spare(ball_field)
      return unless frame.frame_type == 'normal'
      return unless ball_field == :ball_two
      return unless frame.score == 10

      frame.update(frame_type: :spare)
    end

    def should_close?(ball_field)
      return last_frame_should_close?(ball_field) if frame.last_frame?
      return true if frame.score == Frame::TOTAL_POINTS
      return true if ball_field == :ball_two

      false
    end

    def last_frame_should_close?(ball_field)
      return true if ball_field == :ball_three

      if ball_field == :ball_two
        return false if %w[strike spare].include?(frame.frame_type)

        return true
      end

      false
    end

    def close_frame
      frame.update(closed: true)
    end
  end
end
