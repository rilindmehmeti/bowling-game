# frozen_string_literal: true

module Validators
  module Shared
    module Points
      extend ActiveSupport::Concern
      ALLOWED_POINTS = (0..10).freeze
      included do
        validates :points, presence: true
        validates_numericality_of :points
        validates_inclusion_of :points, in: ALLOWED_POINTS
      end
    end
  end
end
