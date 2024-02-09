# frozen_string_literal: true

# Webhooks handler
class WebhooksController < ApplicationController
  before_action :merge_request_body_to_params, only: [:deliver]

  def ping
    render json: { message: 'pong' }, status: 200
  end

  def deliver
    render(**::Webhooks.process(params[:handler], params))
  end

  private

  def merge_request_body_to_params
    raw_body = request.raw_post

    body_params = JSON.parse(raw_body)

    params.merge!(body_params)
  rescue JSON::ParserError
    render json: { error: 'Invalid JSON' }, status: :bad_request
  end
end
