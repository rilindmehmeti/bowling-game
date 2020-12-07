# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frames::AddPoints do
  let(:frame_index) { 1 }
  let(:ball_one) { nil }
  let(:ball_two) { nil }
  let(:ball_three) { nil }
  let(:score) { 0 }
  let(:frame) { FactoryBot.create(:frame, frame_index: frame_index, ball_one: ball_one, ball_two: ball_two, ball_three: ball_three, score: score) }
  let(:points) { 5 }
  let(:object) { described_class.new(frame.id, points) }

  shared_examples 'frame_test' do |ball_one, ball_two, ball_three, frame_type, closed, score|
    it 'should test frame with right values' do
      object.add_points
      frame.reload
      expect(frame.ball_one).to eq ball_one
      expect(frame.ball_two).to eq ball_two
      expect(frame.ball_three).to eq ball_three
      expect(frame.frame_type).to eq frame_type
      expect(frame.closed).to eq closed
      expect(frame.score).to eq score
    end
  end

  context 'normal flow' do
    include_examples 'frame_test', 5, nil, nil, 'normal', false, 5
  end

  context 'completion of frame' do
    context 'when normal regular frame' do
      let(:ball_one) { 3 }
      let(:score) { 3 }
      include_examples 'frame_test', 3, 5, nil, 'normal', true, 8

      context 'when strike' do
        let(:ball_one) { nil }
        let(:points) { 10 }
        let(:score) { 0 }
        include_examples 'frame_test', 10, nil, nil, 'strike', true, 10
      end

      context 'when spare' do
        let(:ball_one) { 3 }
        let(:points) { 7 }
        let(:score) { 3 }
        include_examples 'frame_test', 3, 7, nil, 'spare', true, 10
      end
    end

    context 'when last frame' do
      let(:frame_index) { 10 }
      context 'when strike' do
        let(:points) { 10 }
        include_examples 'frame_test', 10, nil, nil, 'strike', false, 10
      end

      context 'when spare' do
        let(:ball_one) { 3 }
        let(:score) { 3 }
        let(:points) { 7 }
        include_examples 'frame_test', 3, 7, nil, 'spare', false, 10
      end

      context 'when normal' do
        let(:points) { 8 }
        include_examples 'frame_test', 8, nil, nil, 'normal', false, 8
        context 'when normal in second ball' do
          let(:ball_one) { 1 }
          let(:score) { 1 }
          include_examples 'frame_test', 1, 8, nil, 'normal', true, 9
        end
      end
    end
  end
end