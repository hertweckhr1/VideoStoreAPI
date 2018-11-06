class MoviesController < ApplicationController

  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find_by(id: params[:id])

    if @movie.nil?
      render "movies/notfound.json", status: :not_found
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

  def check_out
    @movie = Movie.find_by(id: params[:movie_id])
      if @movie.nil?
        return render "movies/notfound.json", status: :not_found
      end
    @customer = Customer.find_by(id: params[:customer_id])
      if @customer.nil?
        return render "movies/notfound.json", status: :not_found
      end
    if @movie.available? == true && @customer.overdue? == false
      @rental = Rental.new(customer: @customer, movie: @movie,
        checkout_date: Date.current, due_date: Date.current + 7)

      if @rental.save 
        render "movies/checkout.json", status: :ok
      else
        render "rentals/errors.json", status: :bad_request
      end
    end
  end

  def check_in
  end

  private

  def movie_params
    params.permit(:title, :overview, :release_date, :inventory)
  end

end
