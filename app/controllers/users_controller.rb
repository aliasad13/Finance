class UsersController < ApplicationController
  def tmdb_service
    TmdbService.new
  end
  def index
    @users = User.where.not(id: current_user.id).page(params[:page]).per(10)
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = User.find_by(id: [params[:id]])
  end

  def favorite_movies
    user = User.find_by(id: params[:id])
    favorite_movies = user.movies.pluck(:movie_id)
    @favorite_movies = favorite_movies.map { |movie_id| tmdb_service.fetch_movie(movie_id) }.compact
    @genres = tmdb_service.fetch_genre_id
    @genres_hash = @genres["genres"].map { |genre| [genre["id"], genre["name"]] }.to_h
  end

  def friends
    user = User.find_by(id: params[:id])
    @friends = user.friends.where.not(id: current_user.id).page(params[:page]).per(10) if user
  end

end
