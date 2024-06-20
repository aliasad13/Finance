class MediaController < ApplicationController
  before_action :tmdb_service, only: [:index, :movies, :tv_shows]
  before_action :genres, only: [:index, :movies, :tv_shows]

  def tmdb_service
    TmdbService.new
  end

  def genres
    @genres = tmdb_service.fetch_genre_id
    @genres_hash = @genres["genres"].map { |genre| [genre["id"], genre["name"]] }.to_h
  end
  def index
    @trending_movies = tmdb_service.fetch_trending_movies["results"]
    @trending_tv_shows = tmdb_service.fetch_trending_tv_shows["results"]
  end

  def movies
    @trending_movies = tmdb_service.fetch_trending_movies["results"]
  end

  def tv_shows
    @trending_tv_shows = tmdb_service.fetch_trending_tv_shows["results"]
  end

  def movie
    movie_id = params['id'].to_i
    @movie = tmdb_service.fetch_movie(movie_id)
    movie_pictures = tmdb_service.fetch_movie_images(movie_id)
@movie_pictures = movie_pictures["backdrops"]
  end

end