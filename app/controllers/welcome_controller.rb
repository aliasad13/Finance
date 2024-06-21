class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :set_devise_resource, only: :home

  def home
    if user_signed_in?
      flash[:notice] = "Sign Out To Visit Home Page"
      redirect_to new_user_session_path
    end
  end

  private

  def set_devise_resource
    @resource = User.new
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]
  end

end

