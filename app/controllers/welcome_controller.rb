class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
    if user_signed_in?
      flash[:notice] = "Sign Out To Visit Home Page"
      redirect_to new_user_session_path
    end
  end
end