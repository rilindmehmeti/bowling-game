require 'rails_helper'

RSpec.describe V1::GamesController, type: :controller do
  describe 'create' do
    it 'should create a game with 10 frames' do
      post 'create'
      expect(response).to have_http_status(:ok)
      game = Game.find(response.body)
      expect(game).not_to be_nil
      expect(game.frames.length).to eq 10
    end
  end

  describe 'add_points' do
    let(:game) { FactoryBot.create(:game) }
    let(:ball_one) { nil }
    let(:ball_two) { nil }
    let(:ball_three) { nil }
    let!(:frame_one) { FactoryBot.create(:frame, game: game, frame_index: 1, ball_one: ball_one, ball_two: ball_two, ball_three: ball_three) }
    let!(:frame_two) { FactoryBot.create(:frame, game: game, frame_index: 2, ball_one: ball_one, ball_two: ball_two, ball_three: ball_three) }
    let!(:frame_three) { FactoryBot.create(:frame, game: game, frame_index: 3, ball_one: ball_one, ball_two: ball_two, ball_three: ball_three) }
    let(:points) { 5 }
    let(:params) { {id: game.id, points: points} }

    it 'should add points to the right frame' do
      post 'add_points', params: params
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq 'null'
      frame_one.reload
      expect(frame_one.ball_one).to eq points
      expect(frame_one.score).to eq points
    end

    context 'when missing params' do
      it 'should raise error when missing game_id' do
        expect {
          post 'add_points', params: params.except(:id)
        }.to raise_error(ActionController::ParameterMissing)
      end

      it 'should raise error when missing points' do
        expect {
          post 'add_points', params: params.except(:points)
        }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'when invalid points' do
      let(:points) { 20 }
      it 'should have unprocessable entity' do
        post 'add_points', params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'result' do
    let(:game) { FactoryBot.create(:game) }
    let!(:frame_one) { FactoryBot.create(:frame, game: game, frame_index: 1, score: 10) }
    let!(:frame_two) { FactoryBot.create(:frame, game: game, frame_index: 2, score: 20) }
    let(:expected_result) {
      {
          score: 30,
          frame_1: 10,
          frame_2: 20
      }
    }

    it 'should return expected result' do
      post 'result', params: {id: game.id}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq expected_result.with_indifferent_access
    end

    context 'when game is missing' do
      it 'should throw an error' do
        expect{
          post 'result', params: { id: -1 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
