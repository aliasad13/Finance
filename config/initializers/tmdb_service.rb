require 'uri'
require 'net/http'
require 'json'

class TmdbService
  BASE_URL = 'https://api.themoviedb.org/3'.freeze

  def initialize
    @bearer_token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MmM3ZWRhYzE2MTMzMTM0OTRkYTMwMGQ3Zjc4MjYwNCIsInN1YiI6IjY2NzE2MDQ0MzgzYWRiYWZmMGUyMjk1MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.-4xWDMLg1h8_NjNafeezohPp-uf0waGIp4ZOI3wbHL0'
  end

  def fetch_popular_movies
    request_api('/movie/popular?language=en-US&page=1')
  end

  def fetch_popular_tv_shows
    request_api('/tv/popular?language=en-US&page=1')
  end

  def fetch_trending_movies
    request_api('/trending/movie/week?language=en-US')
  end

  def fetch_trending_tv_shows
    request_api('/trending/tv/week?language=en-US')
  end


  private

  def request_api(endpoint)
    url = URI("#{BASE_URL}#{endpoint}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['accept'] = 'application/json'
    request['Authorization'] = "Bearer #{@bearer_token}"

    response = http.request(request)
    JSON.parse(response.read_body)['results']
  end
end
