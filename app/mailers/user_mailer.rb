  class UserMailer < ApplicationMailer
    default from: 'aliasadmshah@gmail.com'

    def welcome_email(user)
      @user = user
      @url  = 'http://localhost:3000/'
      mail(to: @user.email, subject: 'Welcome to Movie Nights')
    end
  end
