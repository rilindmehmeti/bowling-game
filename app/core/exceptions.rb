# frozen_string_literal: true

module Exceptions
  class InvalidInput < RuntimeError; end
  class FrameError < RuntimeError; end
  class InvalidBallField < FrameError; end
end