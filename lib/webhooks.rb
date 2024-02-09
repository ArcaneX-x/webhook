# frozen_string_literal: true

# Base class to register and process webhooks in PMS
class Webhooks
  class << self
    # Cop disabled for this registry pattern intentionally, DO NOT OVERRIDE in a child class
    # Provide access to registry
    # @return [Hash]
    def handlers
      @handlers ||= {}
    end

    def process(key, request)
      handlers[key.to_sym.downcase].new(request).process
    end

    # @param name [String] A string identifier to register, used in settings
    # @param klass [Class] The class of the vendor that implements the interface
    def register_handler(name, klass)
      handlers[name.to_sym.downcase] = klass
    end
  end
end

require_relative './webhook/adyen'

::Webhooks.register_handler(:adyen, ::Webhook::Adyen)

