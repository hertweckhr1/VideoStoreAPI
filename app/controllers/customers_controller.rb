class CustomersController < ApplicationController

  def index
    sort_options = ["name", "registered_at", "postal_code"]
    list = Customer.all
    @customers = sort_and_paginate(sort_options, list, params)
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :registered_at, :address, :city, :state, :postal_code, :phone, :sort, :p, :n)
  end
end
