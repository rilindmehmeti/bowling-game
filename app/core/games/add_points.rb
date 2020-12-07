# frozen_string_literal: true

module Games
  class AddPoints
    attr_accessor :game_id, :points, :validator

    def initialize(game_id, points)
      @game_id = game_id
      @points = points
      @validator = Games::Validators::AddPoints.new(game_id, points)
    end

    def game
      @game ||= Game.find(game_id)
    end

    def current_frame
      @current_frame ||= game.current_frame
    end

    def valid?
      @valid ||= validator.valid?
    end

    def errors
      @errors ||= validator.errors
    end

    def add_points
      points_handler.add_points
    end

    def points_handler
      @points_handler ||= Frames::AddPoints.new(current_frame.id, points)
    end
  end
end
