# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::AddPoints do
  def test_addition_of_points(points, scores = [])
    #return if scores.length != 10

    game = FactoryBot.create(:game)
    frame_1 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 1)
    frame_2 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 2)
    frame_3 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 3)
    frame_4 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 4)
    frame_5 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 5)
    frame_6 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 6)
    frame_7 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 7)
    frame_8 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 8)
    frame_9 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 9)
    frame_10 = FactoryBot.create(:frame, game: game, ball_one: nil, ball_two: nil, ball_three: nil,frame_index: 10)
    points.each do |point|
      described_class.new(game.id, point).add_points
    end
    expect(frame_1.reload.score).to eq scores[0].to_i
    expect(frame_2.reload.score).to eq scores[1].to_i
    expect(frame_3.reload.score).to eq scores[2].to_i
    expect(frame_4.reload.score).to eq scores[3].to_i
    expect(frame_5.reload.score).to eq scores[4].to_i
    expect(frame_6.reload.score).to eq scores[5].to_i
    expect(frame_7.reload.score).to eq scores[6].to_i
    expect(frame_8.reload.score).to eq scores[7].to_i
    expect(frame_9.reload.score).to eq scores[8].to_i
    expect(frame_10.reload.score).to eq scores[9].to_i
  end

  it 'should create games with right scores' do
    test_addition_of_points([1, 3], [4])
    test_addition_of_points([10, 3, 7], [20, 10])
    test_addition_of_points([3, 4, 7, 3, 2, 0, 10, 10, 3, 2], [7, 12, 2, 23, 15, 5])
    test_addition_of_points([3, 4, 7, 3, 2, 0, 10, 10, 3, 2, 1, 1, 4, 4, 10, 10, 10, 10], [7, 12, 2, 23, 15, 5, 2, 8, 30, 30])
    test_addition_of_points([3, 4, 7, 3, 2, 0, 10, 10, 3, 2, 1, 1, 4, 4, 10, 5, 5, 10], [7, 12, 2, 23, 15, 5, 2, 8, 20, 20])

    test_addition_of_points([10, 3, 7, 10, 2, 2], [20, 20, 14, 4])
  end
end