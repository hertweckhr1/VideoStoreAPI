class ApplicationController < ActionController::API

  def current_data(entity)
    list = entity.rentals.where(checkin_date: nil)

    if list.empty?
      render "layouts/empty.json", status: :ok
    else
      return list
    end
  end

  def history_data
  end

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
       binding.pry
       list = list.all.order(params[:sort])
     else
       return bad_request
     end
    else
     list = list.all.order(:id)
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
end
