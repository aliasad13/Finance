require 'oauth2'

MYANIMELIST_CLIENT_ID = Rails.application.credentials.dig(:myanimelist, :client_id)
MYANIMELIST_CLIENT_SECRET = Rails.application.credentials.dig(:myanimelist, :client_secret)

MyAnimeListClient = OAuth2::Client.new(
  MYANIMELIST_CLIENT_ID,
  MYANIMELIST_CLIENT_SECRET,
  site: 'https://myanimelist.net',
  authorize_url: '/v1/oauth2/authorize',
  token_url: '/v1/oauth2/token'
)
