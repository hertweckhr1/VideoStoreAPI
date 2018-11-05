require "test_helper"

describe Movie do
  let(:movie) { movies(:movieone) }

  describe "Validations" do
    it "is valid when all fields are present" do
      expect(movie).must_be :valid?
    end
  end

  describe "Relationships" do
    it "can have many rentals" do
      expect(movie.rentals.count).must_be :>=, 0
    end

    it "can have 0 rentals" do
      movie = Movie.new
      expect(movie.rentals.count).must_equal 0
    end

    it "can access customers through rentals" do
      expect(movie.customers.length).must_be :>=, 0

      movie.customers.each do |customer|
        expect(customer).must_be_instance_of Customer
      end
    end
  end

  describe "Custom Models" do
  end
end
