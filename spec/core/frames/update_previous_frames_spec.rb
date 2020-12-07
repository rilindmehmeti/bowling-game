# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frames::UpdatePreviousFrames do
  let(:game) { FactoryBot.create(:game) }
  let!(:frame_one) { FactoryBot.create(:frame, game: game, frame_index: 1) }
  let!(:frame_two) { FactoryBot.create(:frame, game: game, frame_index: 2) }
  let!(:frame_three) { FactoryBot.create(:frame, game: game, frame_index: 3) }
  let(:object) { described_class.new(frame_three) }

  describe '.do_update' do
    it 'should not change the scores' do
      object.do_updates
      frame_one.reload
      frame_two.reload
      frame_three.reload
      expect(frame_one.score).to eq 0
      expect(frame_two.score).to eq 0
      expect(frame_three.score).to eq 0
    end

    context 'when previous frame is a spare' do
      let!(:frame_two) { FactoryBot.create(:frame, game: game, frame_index: 2, ball_one: 5, ball_two: 5, frame_type: :spare, score: 10) }
      let!(:frame_three) { FactoryBot.create(:frame, game: game, frame_index: 3, ball_one: 7) }
      it 'should change score for frame two' do
        object.do_updates
        frame_one.reload
        frame_two.reload
        frame_three.reload
        expect(frame_one.score).to eq 0
        expect(frame_two.score).to eq 17
        expect(frame_three.score).to eq 0
      end
    end

    context 'when previous frame is a strike' do
      let!(:frame_two) { FactoryBot.create(:frame, game: game, frame_index: 2, ball_one: 10, frame_type: :strike, score: 10) }
      let!(:frame_three) { FactoryBot.create(:frame, game: game, frame_index: 3, ball_one: 7, ball_two: 2) }
      it 'should change score for frame two' do
        object.do_updates
        frame_one.reload
        frame_two.reload
        frame_three.reload
        expect(frame_one.score).to eq 0
        expect(frame_two.score).to eq 19
        expect(frame_three.score).to eq 0
      end
    end

    context 'when double strike' do
      let!(:frame_one) { FactoryBot.create(:frame, game: game, frame_index: 1, ball_one: 10, frame_type: :strike, score: 10) }
      let!(:frame_two) { FactoryBot.create(:frame, game: game, frame_index: 2, ball_one: 10, frame_type: :strike, score: 10) }
      let!(:frame_three) { FactoryBot.create(:frame, game: game, frame_index: 3, ball_one: 3, ball_two: 2) }
      it 'should change score for frame two' do
        object.do_updates
        frame_one.reload
        frame_two.reload
        frame_three.reload
        expect(frame_one.score).to eq 23
        expect(frame_two.score).to eq 15
        expect(frame_three.score).to eq 0
      end
    end
  end

  describe '.previous_frame' do
    let(:frame) { FactoryBot.create(:frame, game: game, frame_index: 9) }
    it 'should return frame two' do
      expect(object.previous_frame).to eq frame_two
    end

    context 'when previous frame index is missing' do
      let(:object) { described_class.new(frame) }
      it 'should return nil' do
        expect(object.previous_frame).to eq nil
      end
    end
  end

  describe '.previous_previous_frame' do
    it 'should return frame one' do
      expect(object.previous_previous_frame).to eq frame_one
    end

    context 'when previous previous frame is missing' do
      let(:object) { described_class.new(frame_two) }
      it 'should return nil' do
        expect(object.previous_previous_frame).to eq nil
      end
    end
  end
end