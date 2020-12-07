# frozen_string_literal: true

class Frame < ApplicationRecord
  ALLOWED_INDEXES = (1..10).freeze
  LAST_INDEX = 10
  FIRST_INDEX = 1
  TOTAL_POINTS = 10
  UNLOCK_BALL_THREE_TYPES = %w[strike spare].freeze

  default_scope { order(frame_index: :asc) }
  belongs_to :game
  validates :game, :frame_index, presence: true
  validates_inclusion_of :frame_index, in: ALLOWED_INDEXES
  validates_uniqueness_of :frame_index, scope: :game_id

  scope :by_index, ->(index) { where(frame_index: index) }
  scope :active, -> { where(closed: false) }

  enum frame_type: {normal: 1,
                    strike: 2,
                    spare: 3}

  def last_frame?
    frame_index == LAST_INDEX
  end

  def current_ball
    return :ball_one if ball_one.nil?
    return :ball_two if ball_two.nil?
    return unless last_frame? && UNLOCK_BALL_THREE_TYPES.include?(frame_type)
    return :ball_three if ball_three.nil?
  end

  def previous_frame
    return if frame_index == FIRST_INDEX

    Frame.find_by(frame_index: previous_frame_index, game: game)
  end

  def previous_frame_index
    frame_index - 1
  end

end
