class CustomersController < ApplicationController

  def index
    @customers = Customer.all
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :registered_at, :address, :city,
      :state, :postal_code, :phone)
  end
end
