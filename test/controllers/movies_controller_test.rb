require "test_helper"

describe MoviesController do
  let(:movie) {movies(:movietwo)}
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
end
