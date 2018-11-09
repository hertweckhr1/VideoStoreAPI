class MoviesController < ApplicationController
  before_action :find_movie, only: [:show, :current, :history]

  def index
    sort_options = ["title", "release_date"]
    list = Movie.all
    @movies = sort_and_paginate(sort_options, list, params)
  end

  def show; end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      render "movies/show.json", status: :ok
    else
      render "movies/errors.json", status: :bad_request
    end
  end

  def current
    @rentals = current_data(@movie)

    if @rentals.empty?
      return render "layouts/empty.json", status: :ok
    end

    @details = multi_table_movie_details(@rentals)
  end

  def history
    @rentals = history_data(@customer)

    if @rentals.empty?
      return render "layouts/empty.json", status: :ok
    end

    @details = multi_table_movie_details(@rentals)
  end

  private

  def movie_params
    params.permit(:title, :overview, :release_date, :inventory, :sort, :p, :n)
  end

  def find_movie
    @movie = Movie.find_by(id: params[:id])

    if @movie.nil?
      render "layouts/notfound.json", status: :not_found
    end
  end
end
