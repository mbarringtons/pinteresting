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
  	http_request_header_keys = request.headers.keys.select{|header_name| header_name.mtch("^HTTP.*")}
  	http_request_headers = request.headers.select{|header_name, header_value| http_request_header_keys.index(header_name)}
  	logger.info "Received #{request.method.inspect} to #{request.url.inspect} from #{request.remote_ip.inspect}. Processing with headers #{http_request_headers.inspect} and params #{params.inspect}"
  	begin
  		yield
  	ensure
  		logger.info "response_status: #{response.status}"
  	end
  end
end