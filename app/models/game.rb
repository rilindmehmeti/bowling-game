# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :frames

  def current_frame
    frames.active.try(:first)
  end

  def total_score
    return 0 if frames.length.zero?

    frames.map { |frame| frame.score }.map(&:to_i).sum
  end
end
