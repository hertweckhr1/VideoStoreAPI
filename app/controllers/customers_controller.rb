class CustomersController < ApplicationController

  def index
    sort_options = ["name", "registered_at", "postal_code"]
    @customers = Customer.all.order(:id)

    if params[:sort]
      if sort_options.include? params[:sort]
        @customers = Customer.all.order(params[:sort])
      else
        return bad_request
      end
    end

    if params[:n]
      return bad_request if !integer?(params[:n])
    end

    if params[:p]
      return bad_request if !integer?(params[:p])
    end

    if params[:n] && params[:p]
      @customers = @customers.paginate(:page => params[:p], :per_page => params[:n])
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :registered_at, :address, :city, :state, :postal_code, :phone, :sort, :p, :n)
  end
end
