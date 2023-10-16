class AuthPagesController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user
  end

  def contact
  end
end
