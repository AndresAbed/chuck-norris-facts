class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  before_action :check_language
  helper_method :check_language

  def check_language
    if cookies[:language].empty?
      cookies[:language] = "eng"
    end
    return cookies[:language]
  end
end