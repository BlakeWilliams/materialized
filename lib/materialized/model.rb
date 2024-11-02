# frozen_string_literal: true

module Materialized
  module Model
    def self.included(mod); end

    def fields
      JSON.parse(super)
    end

    def fields=(value)
      if value.is_a?(String)
        super(value)
      else
        super(value.to_json)
      end
    end
  end
end
