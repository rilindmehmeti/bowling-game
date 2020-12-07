# frozen_string_literal: true

module Frames
  class Initialize
    BALL_DEFAULT_VALUE = nil
    attr_accessor :index
    def initialize(index)
      @index = index
    end

    def self.frame(index)
      new(index).frame
    end

    def frame
      Frame.new(frame_index: index,
                ball_one: BALL_DEFAULT_VALUE,
                ball_two: BALL_DEFAULT_VALUE,
                ball_three: BALL_DEFAULT_VALUE)
    end

  end
end
