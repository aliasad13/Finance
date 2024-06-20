class ApplicationController < ActionController::Base

  # CSRF protection for AJAX requests
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  def dark_mode
    #theme is set on application.html.erb => <html>
    if user_signed_in?
      theme = params[:theme] == 'dark' ? 'dark' : 'retro'
      current_user.update(theme: theme)
      #To ensure that the user is redirected back to the page they
      #were on after setting the theme, you can use the request.referrer
      # request.referrer = "url to the page from which the requwst was send"
      redirect_to request.referrer || root_path
    else
      redirect_to new_user_session_path, alert: 'You need to sign in to change theme'
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def after_sign_in_path_for(resource)
    movies_and_shows_path
  end

end
