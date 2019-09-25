class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @records = current_user.records if current_user
  end
end
