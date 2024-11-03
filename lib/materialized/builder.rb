# frozen_string_literal: true

module Materialized
  class Builder
    # :nodoc:
    class Dependency
      attr_reader :model, :attrs, :on_create, :on_destroy

      def initialize(model, attrs: nil, on_create: nil, on_destroy: nil)
        @model = model
        @attrs = attrs
        @on_create = on_create
        @on_destroy = on_destroy
      end
    end

    def self.model(model, belongs_to:)
      @model = model
      @belongs_to = belongs_to
    end

    def self.model_class
      if @model.is_a?(String)
        @model.constantize
      elsif @model.is_a?(Class)
        @model
      elsif @model.is_a?(Symbol)
        @model.constantize
      else
        raise ArgumentError, 'Model must be a class, string, or symbol'
      end
    end

    def self.mapping
      @_mapping ||= {}
    end

    def self.depends_on(model, attrs: nil, on_create: nil, on_destroy: nil)
      mapping[model] = Dependency.new(model, attrs: attrs, on_create: on_create, on_destroy: on_destroy)
    end
  end
end
