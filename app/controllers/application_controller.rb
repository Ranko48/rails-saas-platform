# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, with: :render404
  protect_from_forgery with: :exception
  around_action :switch_time_zone, if: :current_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:timezone, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:timezone, :email, :password, :current_password) }
  end

  def switch_time_zone(&)
    Time.use_zone(current_user.timezone, &)
  end

  def render404
    render file: "#{Rails.root}/public/404.html", status: 404
  end
end
