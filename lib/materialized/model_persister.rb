# frozen_string_literal: true

module Materialized
  class ModelPersister
    def initialize(model:)
      @persistence_model = model
    end

    def persist(instance, action)
      fields = action == :update ? instance.previous_changes.keys : []

      persistence_model_class.new(
        class_id: instance.id,
        action: action,
        class_name: instance.class.name,
        fields: fields
      ).save
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
