require "test_helper"

# You should have at least one positive and one negative test case for each relation, validation, and custom function you add to your models.

describe Customer do
  let(:customer) { customers(:customerone) }

  describe "Validations" do
    it "is valid when all fields are present" do
      expect(customer).must_be :valid?
    end

    it "requires a name" do
      customer.name = nil
      customer.valid?.must_equal false
      customer.errors.messages.must_include :name
    end

    it "requires registered_at" do
      customer.registered_at = nil
      customer.valid?.must_equal false
      customer.errors.messages.must_include :registered_at
    end

    it "requires an address" do
      customer.address = nil
      customer.valid?.must_equal false
      customer.errors.messages.must_include :address
    end

    it "requires a city" do
      customer.city = nil
      customer.valid?.must_equal false
      customer.errors.messages.must_include :city
    end

    it "requires a state" do
      customer.state = nil
      customer.valid?.must_equal false
      customer.errors.messages.must_include :state
    end

    it "requires a postal_code" do
      customer.postal_code = nil
      customer.valid?.must_equal false
      customer.errors.messages.must_include :postal_code
    end

    it "requires a phone" do
      customer.phone = nil
      customer.valid?.must_equal false
      customer.errors.messages.must_include :phone
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
