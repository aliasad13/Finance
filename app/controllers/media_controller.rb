class MediaController < ApplicationController
  def index
    tmdb_service = TmdbService.new
    @popular_movies = tmdb_service.fetch_popular_movies
    @popular_tv_shows = tmdb_service.fetch_popular_tv_shows
    @trending_movies = tmdb_service.fetch_trending_movies
    @trending_tv_shows = tmdb_service.fetch_trending_tv_shows
  end
end