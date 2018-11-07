class CustomersController < ApplicationController

  def index
    @customers = Customer.all.order(:id)
    sort_options = ["name", "registered_at", "postal_code"]
    if params[:sort]
      if sort_options.include? params[:sort]
        @customers = Customer.all.order(params[:sort])
      else
        return render "layouts/badrequest.json", status: :bad_request
      end
    end

    if params[:n]
      return render "layouts/badrequest.json", status: :bad_request if !integer?(params[:n])
    end

    if params[:p]
      return render "layouts/badrequest.json", status: :bad_request if !integer?(params[:p])
    end

    if params[:n] && params[:p]
        @customers = @customers.paginate(:page => params[:p], :per_page => params[:n])
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :registered_at, :address, :city,
      :state, :postal_code, :phone, :sort, :p, :n)
  end

  def integer?(x)
    if x != x.to_i.to_s
      return false
    elsif x.to_i.integer? && x.to_i > 0
      return true
    else
      return false
    end
  end
end
