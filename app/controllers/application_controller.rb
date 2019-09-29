# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  helper_method :content_layout

  private

  def layout_path(layout_name = :blank)
    "layouts/layouts/#{layout_name}"
  end

  def content_layout
    layout_path
  end
end
