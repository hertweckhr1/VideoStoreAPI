require "test_helper"

describe RentalsController do
  let(:movie) { movies(:movieone) }
  let(:customer) { customers(:customerone) }
  let(:rental) { rentals(:rentalone) }
  let(:customertwo) { customers(:customertwo) }

  describe "check_out" do
    it "can successfully check out a movie" do
      movie = movies(:movieone)
      starting_inventory = movie.available_inventory

      expect {
      post check_out_path, params: {customer_id: customer.id, movie_id: movie.id}
      }.must_change "Rental.count", 1

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "checkout_date"

      movie = Movie.find_by(id: movie.id)
      expect(movie.available_inventory).must_equal (starting_inventory - 1)

    end

    it "does not check out a movie if there is not enough inventory" do
      movie.available_inventory = 0
      movie.save

      expect {
        post check_out_path, params: {customer_id: customer.id, movie_id: movie.id}
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "forbidden"
      must_respond_with :forbidden
    end

    it "does not check out a movie if customer has overdue items" do
      expect {
        post check_out_path, params: {customer_id: customertwo.id, movie_id: movie.id}
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "forbidden"
      must_respond_with :forbidden
    end

    it "does not check out a movie if rental information is invalid " do
      movie = movies(:movieone)
      starting_inventory = movie.available_inventory

      expect {
        post check_out_path, params: {movie_id: movie.id}
      }.wont_change "Rental.count"

      movie = Movie.find_by(id: movie.id)
      expect(movie.available_inventory).must_equal starting_inventory

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "not found"
      must_respond_with :not_found
    end
  end

  describe "check_in" do
    it "successfully checks in a movie" do
      movie = movies(:movieone)
      rental = rentals(:rentalone)
      starting_inventory = movie.available_inventory

      expect {
        post check_in_path, params: {customer_id: customer.id, movie_id: movie.id}
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "checkout_date"

      movie = Movie.find_by(id: movie.id)
      rental = Rental.find_by(id: rental.id)
      expect(movie.available_inventory).must_equal starting_inventory + 1
      expect(rental.checkin_date).wont_be_nil

    end

    it "does not check in a movie if parameters are invalid" do
      movie = movies(:movieone)
      starting_inventory = movie.available_inventory

      expect {
        post check_in_path, params: {customer_id: -1, movie_id: movie.id}
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "not found"
      must_respond_with :not_found

      movie = Movie.find_by(id: movie.id)
      expect(movie.available_inventory).must_equal starting_inventory
    end

    it "does not check in if parameters are missing" do
      movie = movies(:movieone)
      starting_inventory = movie.available_inventory

      expect {
        post check_in_path, params: {movie_id: movie.id}
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "not found"
      must_respond_with :not_found

      movie = Movie.find_by(id: movie.id)
      expect(movie.available_inventory).must_equal starting_inventory
    end
  end

  describe "overdue" do
    it "is a real working route and returns JSON" do
      get overdue_path, as: :json

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "will return all overdue items that have not been checked in" do
      get overdue_path, as: :json

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Array
      expect(body.length).must_equal 1

      expect(body[0]).must_include "movie_id"

      must_respond_with :success
    end

    it "will render layouts/empty when there are no overdue items" do
      rentals(:rentalone).checkin_date = "2018-11-08"
      rentals(:rentalone).save
      rentals(:rentalthree).checkin_date = "2018-10-10"
      rentals(:rentalthree).save

      get overdue_path, as: :json
      # binding.pry
      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "message"
      expect(body["message"]).must_include "no records found"
      must_respond_with :ok
    end
  end
end
