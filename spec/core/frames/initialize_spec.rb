# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frames::Initialize do
  describe '.frame' do

    def test_frame_object(index)
      frame = described_class.frame(index)
      expect(frame).to be_kind_of(Frame)
      expect(frame.id).to eq nil
      expect(frame.ball_one).to eq nil
      expect(frame.ball_two).to eq nil
      expect(frame.ball_three).to eq nil
      expect(frame.frame_type).to eq 'normal'
      expect(frame.closed).to eq false
    end

    it 'should initialize frame object with right values' do
      test_frame_object(1)
      test_frame_object(10)
      test_frame_object(15)
      test_frame_object(20)
    end
  end
end