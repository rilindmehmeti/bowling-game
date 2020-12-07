class GameSerializer < BaseSerializer
  def to_h(params = {})
    result = { score: model.total_score }
    model.frames.each do |frame|
      result["frame_#{frame.frame_index}"] = frame.score.to_i
    end
    result
  end

  alias as_json to_h
end
