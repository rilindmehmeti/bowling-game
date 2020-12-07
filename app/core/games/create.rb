# frozen_string_literal: true

module Games
  class Create
    attr_accessor :game

    def initialize
      @game = Game.new
      create_frames
    end

    def create_frames
      Frame::ALLOWED_INDEXES.each do |index|
        game.frames << ::Frames::Initialize.frame(index)
      end
    end

    def create
      game.save!
      game
    end
  end
end
