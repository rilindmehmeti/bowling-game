module Games
  module Validators
    class AddPoints < ::Validators::Base
      include ::Validators::Shared::Points
      attr_accessor :game_id, :points

      validates :game, :current_frame, presence: true

      def initialize(game_id, points)
        @game_id = game_id
        @points = points
      end

      def game
        @game ||= Game.find_by(id: game_id)
      end

      def current_frame
        @current_frame ||= game.try(:current_frame)
      end
    end
  end
end