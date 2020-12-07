# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frames::Validators::AddPoints do
  let(:points) { 10 }
  let(:frame) { FactoryBot.create(:frame, frame_index: 1) }
  let(:frame_id) { frame.id }
  let(:validator) { described_class.new(frame_id, points) }

  describe '.valid?' do
    it 'should be valid' do
      expect(validator).to be_valid
    end

    context 'when it is not valid' do
      context 'when game_id is missing' do
        let(:frame_id) { nil }
        it 'should be not valid and have game errors' do
          expect(validator).not_to be_valid
          expect(validator.errors[:frame]).to include("can't be blank")
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

      context 'when score would be more than 10' do
        let(:points) { 6 }
        let(:frame) { FactoryBot.create(:frame, frame_index: 1, score: 5) }
        it 'should not be valid and have frame errors' do
          expect(validator).not_to be_valid
          expect(validator.errors[:frame]).to include('After those points score will be invalid')
        end
      end

      context 'when frame is closed' do
        let(:frame) { FactoryBot.create(:frame, frame_index: 1, closed: true) }
        it 'should not be valid and have frame errors' do
          expect(validator).not_to be_valid
          expect(validator.errors[:frame]).to include('Frame is closed')
        end
      end
    end
  end
end