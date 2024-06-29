require 'securerandom'
require 'base64'
require 'digest/sha2'

class MyAnimeListController < ApplicationController
  before_action :set_oauth_client, only: [:authorize, :oauth_callback, :animes, :mangas]

  def authorize
    code_verifier = SecureRandom.urlsafe_base64(64)
    code_challenge = Base64.urlsafe_encode64(Digest::SHA256.digest(code_verifier)).gsub('=', '')
    session[:myanimelist_code_verifier] = code_verifier
    authorize_url = @my_anime_list_client.auth_code.authorize_url(
      redirect_uri: oauth_callback_url,
      response_type: 'code',
      code_challenge: code_challenge,
      code_challenge_method: 'plain',
      state: SecureRandom.hex(16)
    )
    redirect_to authorize_url
  end


  def oauth_callback

    code_verifier = session.delete(:myanimelist_code_verifier)
    token = @my_anime_list_client.auth_code.get_token(code: params[:code], grant_type: 'authorization_code', redirect_uri: oauth_callback_url, code_verifier: code_verifier)
    session[:myanimelist_access_token] = token.token
    redirect_to animes_path
  end



  def set_oauth_client
    #we have already defined as constants in initializers
      client_id = Rails.application.credentials.dig(:myanimelist, :client_id)
      client_secret = Rails.application.credentials.dig(:myanimelist, :client_secret)
      @my_anime_list_client = OAuth2::Client.new(
        client_id,
        client_secret,
        site: 'https://myanimelist.net',
        authorize_url: '/v1/oauth2/authorize',
        token_url: '/v1/oauth2/token'
      )
  end
end
