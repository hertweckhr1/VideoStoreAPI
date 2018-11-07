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
end
