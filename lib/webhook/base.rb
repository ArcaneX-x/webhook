# frozen_string_literal: true

module Webhook
  class Base
    attr_reader :request

    def initialize(request)
      @request = request
    end

    def process
      raise ::NotImplementedError, "#{self.class} does not implement #{__method__}"
    end

    private

    def logger(message)
      @logger ||= Rails.logger
      @logger.info "Webhook error: #{message}"
    end

    def timed_retry(error_message:, seconds: 10)
      time_limit = seconds.seconds.from_now
      begin
        yield
      rescue StandardError
        # Try again until time limit
        unless 2.seconds.from_now > time_limit
          # If timer isn't expired, wait 1 seconds and try again
          sleep(2)
          retry
        end

        logger error_message
        false
      end
    end
  end
end
