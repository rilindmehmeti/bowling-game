# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frame, type: :model do
  let(:frame_index) { 1 }
  let(:game) { FactoryBot.create(:game) }
  let(:creation_params) { {game: game, frame_index: frame_index} }

  describe '.valid?' do
    let(:frame) { described_class.new(creation_params) }
    it 'should be valid' do
      expect(frame).to be_valid
    end

    context 'when game is missing' do
      let(:game) { nil }
      it 'should not be valid and should have game error' do
        expect(frame).not_to be_valid
        expect(frame.errors[:game]).to include("can't be blank")
      end
    end

    context 'when frame_index is missing' do
      let(:frame_index) { nil }
      it 'should not be valid and have frame_index error' do
        expect(frame).not_to be_valid
        expect(frame.errors[:frame_index]).to include("can't be blank")
        expect(frame.errors[:frame_index]).to include('is not included in the list')
      end
    end

    context 'when frame_index is not included in the list' do
      let(:frame_index) { 20 }
      it 'should not be valid and have frame_index error' do
        expect(frame).not_to be_valid
        expect(frame.errors[:frame_index]).to include('is not included in the list')
      end
    end

    context 'when frame already exists for the given index' do
      let!(:frame_one) do
        FactoryBot.create(:frame, game: game, frame_index: frame_index)
      end

      it 'should not be valid and have frame_index error' do
        expect(frame).not_to be_valid
        expect(frame.errors[:frame_index]).to include('has already been taken')
      end
    end
  end

  describe '.last_frame?' do
    let(:frame) { described_class.create(creation_params) }
    it 'should be false' do
      expect(frame.last_frame?).to be_falsey
    end

    context 'when it is the last frame' do
      let(:frame_index) { 10 }
      it 'should be true' do
        expect(frame.last_frame?).to be_truthy
      end
    end
  end

  describe '.current_ball' do
    let(:ball_one) { nil }
    let(:ball_two) { nil }
    let(:ball_three) { nil }
    let(:frame_type) { :normal }
    let(:frame) { FactoryBot.create(:frame, frame_index: frame_index, ball_one: ball_one, ball_two: ball_two, ball_three: ball_three, frame_type: frame_type) }
    context 'when all the ball fields are nil' do
      it 'should return ball_one' do
        expect(frame.current_ball).to eq :ball_one
      end
    end

    context 'when ball one is not empty but ball three and two are empty' do
      let(:ball_one) { 5 }
      it 'should return ball_two' do
        expect(frame.current_ball).to eq :ball_two
      end
    end

    context 'when ball one and two are filled' do
      let(:ball_one) { 5 }
      let(:ball_two) { 7 }
      it 'should return nil' do
        expect(frame.current_ball).to eq nil
      end

      context 'when last frame' do
        let(:frame_index) { 10 }
        it 'should return' do
          expect(frame.current_ball).to eq nil
        end

        context 'when ball strike or spare' do
          context 'when spare' do
            let(:frame_type) { :spare }

            it 'should return ball three' do
              expect(frame.current_ball).to eq :ball_three
            end

            context 'when 3d ball is filled' do
              let(:ball_three) { 3 }
              it 'should return nil' do
                expect(frame.current_ball).to eq nil
              end
            end
          end

          context 'when strike' do
            let(:frame_type) { :strike }

            it 'should return ball three' do
              expect(frame.current_ball).to eq :ball_three
            end

            context 'when 3d ball is filled' do
              let(:ball_three) { 3 }
              it 'should return nil' do
                expect(frame.current_ball).to eq nil
              end
            end
          end
        end
      end
    end
  end

  describe '.previous_frame' do
    let!(:previous_frame) { FactoryBot.create(:frame, game: game, frame_index: frame_index) }
    let(:frame) { FactoryBot.create(:frame, game: game, frame_index: frame_index + 1) }

    it 'should return frame with same game with one less index' do
      expect(frame.previous_frame).to eq previous_frame
    end

    context 'when is the first frame' do
      let(:frame) do
        return previous_frame if frame_index == 1

        FactoryBot.create(:frame, game: game, frame_index: 1)
      end
      it 'should return nil' do
        expect(frame.previous_frame).to eq nil
      end
    end

    context 'when there is not a frame for the same game with one index less' do
      let(:frame) { FactoryBot.create(:frame, game: game, frame_index: frame_index + 2) }
      it 'should return nil' do
        expect(frame.previous_frame).to eq nil
      end
    end
  end
end
