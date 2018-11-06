require "test_helper"

# You should have at least one positive and one negative test case for each relation, validation, and custom function you add to your models.

describe Movie do
  let(:movie) { movies(:movieone) }

  describe "Validations" do
    it "is valid when all fields are present" do
      expect(movie).must_be :valid?
    end

    it "requires a title" do
      movie.title = nil
      movie.valid?.must_equal false
      movie.errors.messages.must_include :title
    end

    it "requires a overview" do
      movie.overview = nil
      movie.valid?.must_equal false
      movie.errors.messages.must_include :overview
    end

    it "requires a release_date" do
      movie.release_date = nil
      movie.valid?.must_equal false
      movie.errors.messages.must_include :release_date
    end

    it "requires a inventory" do
      movie.inventory = nil
      movie.valid?.must_equal false
      movie.errors.messages.must_include :inventory
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

  describe "Custom Methods" do
    describe "available?" do
      it "returns true if available inventory is greater than 0" do
        expect(movie.available?).must_equal true
      end

      it "returns false if available inventory is 0" do
        movie.available_inventory = 0
        expect(movie.available?).must_equal false
      end
    end
  end
end
