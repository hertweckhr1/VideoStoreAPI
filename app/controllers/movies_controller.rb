class MoviesController < ApplicationController

  def index
    @movies = Movie.all
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

  def checkout
    @movie = Movie.find_by(id: params[:movie_id])
    if @movie.nil?
      return render "layouts/notfound.json", status: :not_found
    end

    @customer = Customer.find_by(id: params[:customer_id])
    if @customer.nil?
      return render "layouts/notfound.json", status: :not_found
    end

    if @movie.available? == true && @customer.overdue_items? == false
      @rental = Rental.new(customer: @customer, movie: @movie,
        checkout_date: Date.current, due_date: Date.current + 7)

      if @rental.save
        @movie.available_inventory -= 1
        @movie.save
        @customer.movies_checked_out_count += 1
        @customer.save

        render "rentals/checkout.json", status: :ok
      else
        render "rentals/errors.json", status: :bad_request
      end
    else
      render "rentals/denied.json", status: :forbidden
    end
  end

  def checkin
    @movie = Movie.find_by(id: params[:movie_id])
    if @movie.nil?
      return render "layouts/notfound.json", status: :not_found
    end

    @customer = Customer.find_by(id: params[:customer_id])
    if @customer.nil?
      return render "layouts/notfound.json", status: :not_found
    end

    @rental = Rental.where(customer_id: @customer.id, movie_id: @movie.id).order(checkout_date: :asc).first
    if @rental.nil?
      return render "layouts/notfound.json", status: :not_found
    else
      @rental.checkin_date = DateTime.current
      @movie.available_inventory += 1
      @movie.save
      @customer.movies_checked_out_count -= 1
      @customer.save
      @rental.save

      render "rentals/checkout.json", status: :ok
    end


  end

  private

  def movie_params
    params.permit(:title, :overview, :release_date, :inventory)
  end

end
