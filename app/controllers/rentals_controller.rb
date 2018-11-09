class RentalsController < ApplicationController
  before_action :find_movie, except: [:overdue]
  before_action :find_customer, except: [:overdue]

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
    @rental = Rental.where(customer_id: @customer.id, movie_id: @movie.id).where(checkin_date: nil).order(checkout_date: :asc).first

    if @rental.nil?
      return render "layouts/notfound.json", status: :not_found
    else
      @rental.check_in_transaction(@customer, @movie)
      render "rentals/transaction.json", status: :ok
    end
  end

  def overdue
    sort_options = ["movie_id", "title", "customer_id", "name", "postal_code", "checkout_date", "due_date"]

    @rentals = Rental.all.where(checkin_date: nil).where("due_date < ?", Date.current)

    if @rentals.empty?
      return render "layouts/empty.json", status: :ok
    end

    @details = []
    @rentals.each do |rental|
      @details << {
        "movie_id" => rental.movie_id,
        "title" => rental.movie.title,
        "customer_id" => rental.customer_id,
        "name" => rental.customer.name,
        "postal_code" => rental.customer.postal_code,
        "checkout_date" => rental.checkout_date,
        "due_date" =>  rental.due_date
      }
    end
    @details = sort_and_paginate(sort_options, @details, params)

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
