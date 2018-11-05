require "test_helper"

describe Rental do
  let(:rental) { rentals(:rentalone) }
  let(:customertwo) { customers(:customertwo) }
  let(:movietwo) { movies(:movietwo) }
  
  describe "Validations" do
    it "won't be valid without customer_id or movie_id" do
      rental = Rental.new
      expect(rental).wont_be :valid?
    end

    it "will be valid given a customer_id and movie_id" do
      expect(rental).must_be :valid?
    end

    it "must have a customer_id" do
      rental.customer_id = nil

      valid = rental.valid?

      expect(valid).must_equal false
      expect(rental.errors.messages).must_include :customer
    end

    it "must have a movie_id" do
      rental.movie_id = nil

      valid = rental.valid?

      expect(valid).must_equal false
      expect(rental.errors.messages).must_include :movie
    end

  end

  describe "Relationships" do
    it "belongs to a customer" do
      expect(rental.customer).must_equal customers(:customerone)
    end

    it "can set the user through .customer" do
      rental.customer = customertwo
      expect(rental.customer_id).must_equal customertwo.id
    end

    it "can set the user through .customer_id" do
      rental.customer_id = customertwo.id
      expect(rental.customer).must_equal customertwo
    end

    it "belongs to a movie" do
      expect(rental.movie).must_equal movies(:movieone)
    end

    it "can set the work through .movie" do
      rental.movie = movietwo
      expect(rental.movie_id).must_equal movietwo.id
    end

    it "can set the work through .movie_id" do
      rental.movie_id = movietwo.id
      expect(rental.movie).must_equal movietwo
    end
  end

  describe "Custom Models" do
  end
end
