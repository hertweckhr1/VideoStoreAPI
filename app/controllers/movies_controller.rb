class MoviesController < ApplicationController

  def index
    sort_options = ["title", "release_date"]
    list = Movie.all
    @movies = sort_and_paginate(sort_options, list, params)
  end

  def show
    @movie = Movie.find_by(id: params[:id])

    if @movie.nil?
      render "layouts/notfound.json", status: :not_found
    else
      render "movies/show.json", status: :ok
    end
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      render "movies/show.json", status: :ok
    else
      render "movies/errors.json", status: :bad_request
    end
  end

  private

  def movie_params
    params.permit(:title, :overview, :release_date, :inventory, :sort, :p, :n)
  end
end
