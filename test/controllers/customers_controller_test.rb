require "test_helper"

describe CustomersController do
  let(:customer) {customers(:customertwo)}
  describe "index" do
    it "is a real working route and returns JSON" do
      get customers_path, as: :json

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns an array" do
      get customers_path, as: :json

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Array
    end

    it "returns all of the customers" do
      get customers_path, as: :json

      body = JSON.parse(response.body)

      expect(body.length).must_equal Customer.count
    end

    it "returns customers with exactly the required fields" do
      fields = %w(id movies_checked_out_count name ok phone postal_code registered_at)

      get customers_path, as: :json

      body = JSON.parse(response.body)

      body.each do |customer|
        expect(customer.keys.sort).must_equal fields
        expect(customer.keys.length).must_equal fields.length
      end
    end

    it "successfully returns sorted array given a valid query parameter" do
      get customers_path, params: {format: "json", sort: "name"}
      body = JSON.parse(response.body)

      expect(body[0]["name"]).must_be :<, body[-1]["name"]
      must_respond_with :success
    end

    it "renders badrequest json if given an invalid sort query parameter" do
      get customers_path, params: {format: "json", sort: "pina"}
      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "bad request"
      must_respond_with :bad_request
    end

    it "paginates accurately given valid query parameters" do
      get customers_path, params: {format: "json", n: 10, p: 1 }
      body = JSON.parse(response.body)

      expect(body.length).must_equal 2
      must_respond_with :success
    end

    it "renders bad request given invalid paginate query parameters" do
      get customers_path, params: {format: "json", n: 10, p: 1.5 }

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "bad request"
      must_respond_with :bad_request
    end

    it "sorts and paginates correctly given valid query parameters" do
      get customers_path, params: {format: "json", sort: "name", n: 10, p: 1 }
      body = JSON.parse(response.body)

      expect(body.length).must_equal 2
      expect(body[0]["name"]).must_be :<, body[-1]["name"]
      must_respond_with :success
    end
  end

  describe "zomg" do
    it "works" do
      get zomg_path, as: :json

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end
  end

  describe "current" do
    it "is a working route and returns json" do
      get customers_current_path(customer.id), as: :json

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns an array" do
      get customers_current_path(customer.id), as: :json

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Array
    end

    it "returns an empty message if no results are found" do
      Rental.destroy_all

      get customers_current_path(customer.id), as: :json
      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "no records found"
      must_respond_with :success
    end
  end

  describe "history" do
    it "is a working route and returns json" do
      get customers_history_path(customer.id), as: :json

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns an array" do
      get customers_history_path(customer.id), as: :json

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Array
    end

    it "returns an empty message if no results are found" do
      Rental.destroy_all

      get customers_history_path(customer.id), as: :json
      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "no records found"
      must_respond_with :success
    end
  end
end
