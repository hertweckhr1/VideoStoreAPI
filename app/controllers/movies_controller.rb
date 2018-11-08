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
    sort_options = ["name", "postal_code"]
    list = current_data(@movie)
    @rentals = sort_and_paginate(sort_options, list, params)
  end

  def history
    @rentals = @movie.rentals.select {|rental| rental.checkout_date < Date.current}

    if @rentals.empty?
      render "layouts/empty.json", status: :ok
    else
      render "movies/currenthistory.json", status: :ok
    end
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
