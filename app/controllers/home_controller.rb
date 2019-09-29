class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  helper_method :content_layout

  def index
    @records = current_user.records if current_user
  end

  private

  def content_layout
    current_user ? layout_path(:dashboard) : layout_path(:fullwidth)
  end
end
