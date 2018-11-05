class CustomersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @customers = Customer.all

    render json: @customers
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :registered_at, :address, :city,
      :state, :postal_code, :phone)
  end
end
