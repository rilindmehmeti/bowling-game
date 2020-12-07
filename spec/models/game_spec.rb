# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '.current_frame' do
    let(:game) { FactoryBot.create(:game) }
    context 'when there are frames' do
      let!(:frame_one) { FactoryBot.create(:frame, frame_index: 1, game: game) }
      let!(:frame_two) { FactoryBot.create(:frame, frame_index: 2, game: game) }
      it 'should return frame one' do
        expect(game.current_frame).to eq frame_one
      end

      context 'when there are frames but some are closed' do
        let!(:frame_one) { FactoryBot.create(:frame, frame_index: 1, game: game, closed: true) }
        let!(:frame_two) { FactoryBot.create(:frame, frame_index: 2, game: game) }
        let!(:frame_three) { FactoryBot.create(:frame, frame_index: 3, game: game) }
        it 'should return frame two' do
          expect(game.current_frame).to eq frame_two
        end
      end

      context 'when there are frames but all are closed' do
        let!(:frame_three) { FactoryBot.create(:frame, frame_index: 3, game: game, closed: true) }
        let!(:frame_one) { FactoryBot.create(:frame, frame_index: 1, game: game, closed: true) }
        let!(:frame_two) { FactoryBot.create(:frame, frame_index: 2, game: game, closed: true) }
        it 'should return nil' do
          expect(game.current_frame).to eq nil
        end
      end
    end

    context 'when there are no frames' do
      it 'should return nil' do
        expect(game.current_frame).to eq nil
      end
    end
  end

  describe '.total_score' do
    let(:game) { FactoryBot.create(:game) }
    it 'should return 0' do
      expect(game.total_score).to eq 0
    end

    context 'when there are frames' do
      let!(:frame_one) { FactoryBot.create(:frame, frame_index: 1, game: game, score: 10) }
      let!(:frame_two) { FactoryBot.create(:frame, frame_index: 2, game: game, score: nil) }
      let!(:frame_three) { FactoryBot.create(:frame, frame_index: 3, game: game, score: 5) }
      it 'should return 15' do
        expect(game.total_score).to eq 15
      end
    end
  end
end
