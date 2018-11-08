class CustomersController < ApplicationController
  before_action :find_customer, only: [:current, :history]

  def index
    sort_options = ["name", "registered_at", "postal_code"]
    list = Customer.all
    @customers = sort_and_paginate(sort_options, list, params)
  end

  def zomg
    render "customers/zomg.json.rabl", status: :ok
  end

  def current
    @rentals = @customer.rentals.select {|rental| rental.checkin_date == nil}

    if @rentals.empty?
      render "layouts/empty.json", status: :ok
    else
      render "customers/currenthistory.json", status: :ok
    end
  end

  def history
    @rentals = @customer.rentals.select {|rental| rental.checkout_date < Date.current}

    if @rentals.empty?
      render "layouts/empty.json", status: :ok
    else
      render "customers/currenthistory.json", status: :ok
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :registered_at, :address, :city, :state, :postal_code, :phone, :sort, :p, :n)
  end

  def find_customer
    @customer = Customer.find_by(id: params[:id])

    if @customer.nil?
      return render "layouts/notfound.json", status: :not_found
    end
  end
end
