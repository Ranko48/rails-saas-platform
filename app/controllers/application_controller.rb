# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, with: :render_404

  def render_404
    render file: "#{Rails.root}/public/404.html", status: 404
  end
end
