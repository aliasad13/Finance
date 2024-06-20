require 'uri'
require 'net/http'
require 'json'

class TmdbService
  BASE_URL = 'https://api.themoviedb.org/3'.freeze

  def initialize
    @bearer_token = Rails.application.credentials.dig(:tmdb, :access_token)
    @api_key = Rails.application.credentials.dig(:tmdb, :api_key)
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

  def fetch_genre_id
    response = request_api('/genre/movie/list?language=en-US')
    response || default_genres
  end

  def fetch_movie(movie_id)
    request_api("/movie/#{movie_id}?language=en-US")
  end

  def fetch_movie_images(movie_id)
    request_api("/movie/#{movie_id}/images")
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
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to fetch data from TMDb: #{response.code} #{response.message}"
      nil
    end
  end

  def default_genres
    {
      "genres" => [
        { "id" => 28, "name" => "Action" }, { "id" => 12, "name" => "Adventure" },
        { "id" => 16, "name" => "Animation" }, { "id" => 35, "name" => "Comedy" },
        { "id" => 80, "name" => "Crime" }, { "id" => 99, "name" => "Documentary" },
        { "id" => 18, "name" => "Drama" }, { "id" => 10751, "name" => "Family" },
        { "id" => 14, "name" => "Fantasy" }, { "id" => 36, "name" => "History" },
        { "id" => 27, "name" => "Horror" }, { "id" => 10402, "name" => "Music" },
        { "id" => 9648, "name" => "Mystery" }, { "id" => 10749, "name" => "Romance" },
        { "id" => 878, "name" => "Science Fiction" }, { "id" => 10770, "name" => "TV Movie" },
        { "id" => 53, "name" => "Thriller" }, { "id" => 10752, "name" => "War" },
        { "id" => 37, "name" => "Western" }
      ]
    }
  end
end
