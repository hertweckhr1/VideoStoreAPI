require "test_helper"

# You should have at least one positive and one negative test case for each relation, validation, and custom function you add to your models.

describe Customer do
  let(:customer) { customers(:customerone) }

  describe "Validations" do
    it "is valid when all fields are present" do
      expect(customer).must_be :valid?
    end
  end

  describe "Relationships" do
    it "can have many rentals" do
      expect(customer.rentals.count).must_be :>=, 0
    end

    it "can have 0 rentals" do
      customer = Customer.new
      expect(customer.rentals.count).must_equal 0
    end

    it "can access movies through rentals" do
      expect(customer.movies.length).must_be :>=, 0

      customer.movies.each do |movie|
        expect(movie).must_be_instance_of Movie
      end
    end
  end

  describe "Custom Models" do
  end
end
