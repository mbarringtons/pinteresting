class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  around_filter	:global_request_logging

  protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  def global_request_logging
  	logger.info "USERAGENT: #{request.headers['HTTP_USER_AGENT']}"
  	begin
  		yield
  	ensure
  		logger.info "response_status: #{response.status}"
  	end
  end
end