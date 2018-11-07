class RentalsController < ApplicationController
  before_action :find_movie
  before_action :find_customer

  def checkout
    if @movie.available? && !@customer.overdue_items?

      @rental = Rental.create_rental(@customer, @movie)

      if @rental.save
        @rental.check_out_transaction(@customer, @movie)
        render "rentals/transaction.json", status: :ok
      else
        render "rentals/errors.json", status: :bad_request
      end

    elsif !@movie.available?
      render "rentals/denied_movie.json", status: :forbidden
    else
      render "rentals/denied_customer.json", status: :forbidden
    end
  end

  def checkin
    @rental = Rental.where(customer_id: @customer.id, movie_id: @movie.id).order(checkout_date: :asc).first

    if @rental.nil?
      return render "layouts/notfound.json", status: :not_found
    else
      @rental.check_in_transaction(@customer, @movie)
      render "rentals/transaction.json", status: :ok
    end
  end

  private

  def rental_params
    params.permit(:movie_id, :customer_id)
  end

  def find_movie
    @movie = Movie.find_by(id: params[:movie_id])

    if @movie.nil?
      return render "layouts/notfound.json", status: :not_found
    end
  end

  def find_customer
    @customer = Customer.find_by(id: params[:customer_id])

    if @customer.nil?
      return render "layouts/notfound.json", status: :not_found
    end
  end
end
