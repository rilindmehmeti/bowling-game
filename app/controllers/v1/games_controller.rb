# frozen_string_literal: true

class V1::GamesController < ApplicationController
  before_action :set_game, only: :result
  def create
    response = CreateGameService.call
    render json: response[:data], status: response[:status]
  end

  def add_points
    response = AddPointsService.call(add_points_params)
    render json: response[:data], status: response[:status]
  end

  def result
    render json: GameSerializer.new(@game)
  end

  protected

  def set_game
    @game = Game.find(params[:id])
  end

  def add_points_params
    {game_id: params.require(:id), points: params.require(:points).to_i}
  end
end
