class ApplicationController < ActionController::API

  private

  def bad_request
    render "layouts/badrequest.json", status: :bad_request
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

  def sort_and_paginate(options, list, params)
    if params[:sort]
     if options.include? params[:sort]
       if list.class == Array
         list = list.sort_by{|item| item[params[:sort]]}
       else
         list = list.all.order(params[:sort])
       end
     else
       return bad_request
     end
    else
     list = list.all.order(:id) if list.class != Array
    end

    if params[:n]
      return bad_request if !integer?(params[:n])
    end

    if params[:p]
      return bad_request if !integer?(params[:p])
    end

    if params[:p] || params[:n]
      list = list.paginate(:page => params[:p], :per_page => params[:n])
    end

    return list
  end

  def current_data(entity)
    list = entity.rentals.where(checkin_date: nil)

    return list
  end

  def history_data(entity)
    list = entity.rentals.select {|rental| rental.checkout_date < Date.current}

    return list
  end

  def multi_table_movie_details(list)
    sort_options = ["customer_id", "name", "postal_code", "checkout_date","due_date"]

    details = []
    list.each do |rental|
      details << {
        "customer_id" => rental.customer_id,
        "name" => rental.customer.name,
        "postal_code" => rental.customer.postal_code,
        "checkout_date" => rental.checkout_date,
        "due_date" => rental.due_date
      }
    end

    return sort_and_paginate(sort_options, details, params)
  end

  def multi_table_customer(list)
    sort_options = ["title", "checkout_date", "due_date"]

    details = []
    list.each do |rental|
      details << {
        "title" => rental.movie.title,
        "checkout_date" => rental.checkout_date,
        "due_date" => rental.due_date
      }
    end

    return sort_and_paginate(sort_options, details, params)
  end
end
