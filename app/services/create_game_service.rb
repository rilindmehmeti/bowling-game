class CreateGameService < BaseService
  def call
    game = creator_object.create
    returned_format(:ok, game.id)
  end

  def creator_object
    creator_class.constantize.new
  end

  def creator_class
    params.fetch(:game_creator) { 'Games::Create' }
  end
end