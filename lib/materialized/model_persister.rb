# frozen_string_literal: true

module Materialized
  class ModelPersister
    def initialize(model:)
      @persistence_model = model
    end

    def persist(instance)
      persistence_model_class.new(id: instance.id, type: instance.class.name, fields: instance.changed).save
    end

    private

    def persistence_model_class
      # This is the worst indentation, but it's using standard... :(
      @persistence_model_class ||= if @persistence_model.is_a?(String)
                                     @persistence_model.constantize
                                   else
                                     @persistence_model
                                   end
    end
  end
end
