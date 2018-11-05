class MoviesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @movies = Movie.all

    render json: @movies
  end

  def show
    @movie = Movie.find_by(id: params[:id])

    if @movie.nil?
      render json: { ok: false, message: 'not found' }, status: :not_found
    else
      render json: @movie(except: [:created_at, :updated_at]), status: :ok
    end
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      render json: { ok: true,
      movie = @movie.as_json(except: [:created_at, :updated_at])}
    else
      render json: {
        ok: false,
        message: @movie.errors.messages
      }, status: :bad_request
    end 

  end

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :release_date, :inventory)
  end

end
