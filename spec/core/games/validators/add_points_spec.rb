# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::Validators::AddPoints do
  let(:game) { FactoryBot.create(:game) }
  let!(:frame) { FactoryBot.create(:frame, game: game, frame_index: 1) }
  let(:game_id) { game.id }
  let(:points) { 10 }
  let(:validator) { described_class.new(game_id, points) }

  describe '.valid?' do
    it 'should be valid' do
      expect(validator).to be_valid
    end

    context 'when it is not valid' do
      context 'when game_id is missing' do
        let(:game_id) { nil }
        it 'should be not valid and have game errors' do
          expect(validator).not_to be_valid
          expect(validator.errors[:game]).to include("can't be blank")
        end
      end

      context 'when game_id is not in record ids' do
        let(:game_id) { Game.last.try(:id).to_i + 20 }
        it 'should be not valid and have game errors' do
          expect(validator).not_to be_valid
          expect(validator.errors[:game]).to include("can't be blank")
        end
      end

      context 'when points are missing' do
        let(:points) { nil }
        it 'should be not valid and have points errors' do
          expect(validator).not_to be_valid
          expect(validator.errors[:points]).to include("can't be blank")
        end
      end

      context 'when points are not in the points interval' do
        let(:points) { 20 }
        it 'should be not valid and have points errors' do
          expect(validator).not_to be_valid
          expect(validator.errors[:points]).to include('is not included in the list')
        end
      end

      context 'when there is no open frame' do
        let!(:frame) { FactoryBot.create(:frame, game: game, frame_index: 1, closed: true) }
        it 'should be not valid and current_frame errors' do
          expect(validator).not_to be_valid
          expect(validator.errors[:current_frame]).to include("can't be blank")
        end
      end

      context 'when there is no frame' do
        let!(:frame) { nil }
        it 'should be not valid and current_frame errors' do
          expect(validator).not_to be_valid
          expect(validator.errors[:current_frame]).to include("can't be blank")
        end
      end
    end
  end
end