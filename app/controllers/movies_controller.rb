class MoviesController < ApplicationController


  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find_by(id: params[:id])
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
    params.require(:movie).permit(:title, :overview, :release_date, :inventory)
  end

end