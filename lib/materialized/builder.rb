# frozen_string_literal: true

module Materialized
  class Builder
    def self.update_mapping
      @update_mapping ||= {}
    end

    def self.creation_mapping
      @creation_mapping ||= Set.new
    end

    def self.destruction_mapping
      @destruction_mapping ||= Set.new
    end

    def self.depends_on(model, *fields)
      update_mapping[model] ||= Set.new
      update_mapping[model].merge(fields)
    end

    def self.depends_on_creation_of(model)
      creation_mapping << model
    end

    def self.depends_on_destruction_of(model)
      destruction_mapping << model
    end
  end
end
