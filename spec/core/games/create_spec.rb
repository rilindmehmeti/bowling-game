# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::Create do
  let(:object) { described_class.new }
  describe '.create' do
    let(:game) { object.create }
    it 'should create a game record' do
      expect(game).to be_kind_of(Game)
      expect(game.id).not_to be_nil
    end

    it 'should create 10 frames' do
      expect(game.frames.length).to eq 10
    end

    it 'should create frames for each index' do
      Frame::ALLOWED_INDEXES.each do |index|
        frame = game.frames.by_index(index)
        expect(frame.length).to eq 1
      end
    end

    it 'should create frames with default values' do
      game.frames.each do |frame|
        expect(frame.ball_one).to eq nil
        expect(frame.ball_two).to eq nil
        expect(frame.ball_three).to eq nil
        expect(frame.frame_type).to eq 'normal'
        expect(frame.closed).to eq false
      end
    end
  end
end