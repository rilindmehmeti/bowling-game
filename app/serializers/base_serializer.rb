# frozen_string_literal: true

class BaseSerializer
  attr_accessor :model

  def initialize(model)
    @model = model
  end

  def to_h(_params)
    model
  end

  alias as_json to_h
end
