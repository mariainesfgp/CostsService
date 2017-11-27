class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate

  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == ENV['user'] && password == ENV['password']
    end
  end

  def health_check
    Cost.all
    render :json => {:ok => true}
  end

end
