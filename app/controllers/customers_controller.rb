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
    @rentals = current_data(@customer)

    if @rentals.empty?
      return render "layouts/empty.json", status: :ok
    end

    @details = multi_table_customer(@rentals)
  end

  def history
    @rentals = history_data(@customer)

    if @rentals.empty?
      return render "layouts/empty.json", status: :ok
    end

    @details = multi_table_customer(@rentals)
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
