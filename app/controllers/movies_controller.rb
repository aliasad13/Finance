class MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :tmdb_service, only: [:index, :movies, :tv_shows]

  def tmdb_service
    TmdbService.new
  end

  def add_favorite
    movie = Movie.find_or_create_by(movie_id: params["id"])
    current_user.movies << movie unless current_user.movies.exists?(movie.id)
    @movie = tmdb_service.fetch_movie(params["id"])
    respond_to do |format|
      format.html {redirect_to movie_medium_path(@movie.movie_id), notice: 'Movie was successfully added to your favorites.' }
      format.js
    end
  end

  def remove_favorite
    movie = Movie.find_by(movie_id: params["id"])
    if movie && current_user.movies.exists?(movie.id)
      current_user.movies.delete(movie)
    end
    @movie = tmdb_service.fetch_movie(params["id"])
    respond_to do |format|
      format.html { redirect_to movie_medium_path(@movie.movie_id), notice: 'Movie was successfully removed from your favorites.' }
      format.js
    end
  end

  def favorites
    favorite_movies = current_user.movies.pluck(:movie_id)
    @favorite_movies = favorite_movies.map { |movie_id| tmdb_service.fetch_movie(movie_id) }.compact
    @genres = tmdb_service.fetch_genre_id
    @genres_hash = @genres["genres"].map { |genre| [genre["id"], genre["name"]] }.to_h
  end

end
