require "test_helper"

describe MoviesController do
  let(:movie) { movies(:movieone) }
  let(:customer) { customers(:customerone) }
  let(:rental) { rentals(:rentalone) }
  let(:customertwo) { customers(:customertwo) }

  describe "index" do
    it "is a real working route and returns JSON" do
      get movies_path, as: :json

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns an array" do
      get movies_path, as: :json

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Array
    end

    it "returns all of the movies" do
      get movies_path, as: :json

      body = JSON.parse(response.body)

      expect(body.length).must_equal Movie.count
    end

    it "returns movies with exactly the required fields" do
      fields = %w(id release_date title)

      get movies_path, as: :json

      body = JSON.parse(response.body)

      body.each do |movie|
        expect(movie.keys.sort).must_equal fields
        expect(movie.keys.length).must_equal fields.length
      end
    end
  end

  describe "show" do

    it "is a real working route and returns JSON" do
      # Act
      get movie_path(movie.id), as: :json

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "can get a movie with a valid id" do
      get movie_path(movie.id), as: :json

      code = JSON.parse(response.code)


      must_respond_with :success
      expect(code).must_equal 200
    end

    it "returns not found for movie with invalid id" do
      get movie_path(-1), as: :json

      code = JSON.parse(response.code)

      must_respond_with :not_found
      expect(code).must_equal 404
    end
  end

  describe "create" do
    let(:movie_data) {
      {
        title: "Crazy Rich Asians",
        overview: "Rom Com in Singapore",
        release_date: "2018-08-15",
        inventory: 1
      }
    }

    it "creates a new movie given valid data" do
      expect {
        post movies_path, params: movie_data
      }.must_change "Movie.count", 1

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "id"

      movie = Movie.find_by(id: body["id"].to_i)

      expect(movie.title).must_equal movie_data[:title]
      must_respond_with :success
    end

    it "cannot create a new movie given invalid data" do
      movie_data["title"] = nil

      expect {
        post movies_path, params: movie_data
      }.wont_change "Movie.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "errors"
      expect(body["errors"]).must_include "title"
      must_respond_with :bad_request
    end
  end

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
        post check_in_path, params: {customer: customer, movie: movie}
      }.wont_change "Rental.count"

      movie = Movie.find_by(id: movie.id)
      rental = Rental.find_by(id: rental.id)
      expect(movie.available_inventory).must_equal starting_inventory + 1
      expect(rental.checkin_date).wont_be_nil

    end

    it "does not check in a movie if parameters are invalid" do
      movie = movies(:movieone)
      starting_inventory = movie.available_inventory

      expect {
        post check_in_path, params: {customer: "jane", movie: movie}
      }.wont_change "Rental.count"

      movie = Movie.find_by(id: movie.id)
      expect(movie.available_inventory).must_equal starting_inventory
    end

    it "does not check in if parameters are missing" do
      movie = movies(:movieone)
      starting_inventory = movie.available_inventory

      expect {
        post check_in_path, params: {movie: movie}
      }.wont_change "Rental.count"

      movie = Movie.find_by(id: movie.id)
      expect(movie.available_inventory).must_equal starting_inventory
    end
  end
end
