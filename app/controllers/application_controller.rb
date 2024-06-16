class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # CSRF protection for AJAX requests
  protect_from_forgery with: :exception, prepend: true

  def dark_mode
    #theme is set on application.html.erb => <html>
    if user_signed_in?
      theme = params[:theme] == 'dark' ? 'dark' : 'light'
      current_user.update(theme: theme)
      #To ensure that the user is redirected back to the page they
      #were on after setting the theme, you can use the request.referrer
      # request.referrer = "url to the page from which the requwst was send"
      redirect_to request.referrer || root_path
    else
      redirect_to new_user_session_path, alert: 'You need to sign in to change theme'
    end
  end



end