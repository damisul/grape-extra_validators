# frozen_string_literal: true

require "active_support/all"
require "grape"

module Grape
  module ExtraValidators
    class EndWith < Grape::Validations::Base
      # ------------------------------------------------------------------------------------------------------------------------
      # Methods
      # ------------------------------------------------------------------------------------------------------------------------
      # Public Methods
      # ------------------------------------------------------------------------------------------------------------------------
      def validate_param!(attr_name, params)
        return if !@required && params[attr_name].blank?

        end_with_values = @option.instance_of?(Array) ? @option : [@option]

        # `to_s` is for Symbol.
        parameter = params[attr_name].presence.to_s
        is_valid = end_with_values.any? { |value| parameter.ends_with?(value.to_s) }
        return if is_valid

        allow_values = end_with_values.map { |value| "\"#{value}\"" }
        allow_values[allow_values.length - 1] = "or #{allow_values.last}" if allow_values.length > 1
        message = "must end with #{allow_values.join(", ")}"
        fail Grape::Exceptions::Validation.new(params: [@scope.full_name(attr_name)], message: message)
      end
    end
  end
end
