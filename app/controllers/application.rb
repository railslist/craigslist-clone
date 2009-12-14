# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '059ea7062c3d2de35acda1e5035b12ae'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  helper_method	:admin?
  include SimpleCaptcha::ControllerHelpers 
  
  
  # All exception handler
  def rescue_with_handler(exception)
    render :file => "#{RAILS_ROOT}/public/404.html"
  end
  
  protected
  
  def admin?
    session[:password] == "railslist"
  end
  
  def authorize
    unless admin?
      flash[:error] = "unauthorized access. only administrators are allowed to access that page!"
      redirect_to('/')
      false
    end
  end
  
end
