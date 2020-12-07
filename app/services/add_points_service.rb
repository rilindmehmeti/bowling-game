class AddPointsService < BaseService
  def call
    object = Games::AddPoints.new(game_id, points)
    return returned_format(:unprocessable_entity, object.errors) unless object.valid?

    object.add_points
    returned_format(:ok)
  end

  def game_id
    params.fetch(:game_id)
  end

  def points
    params.fetch(:points)
  end
end