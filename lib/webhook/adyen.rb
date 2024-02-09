# frozen_string_literal: true

module Webhook
  class Adyen < Webhook::Base
    attr_accessor :webhook

    def process
      self.webhook = request[:notificationItems].first[:NotificationRequestItem]

      method = "handle_#{webhook[:eventCode].downcase}".to_sym

      send(method)
    end

    def handle_authorisation
      post = Post.first

      post.update!(title: "new title")

      { plain: '[accepted]' }
    end
  end
end
