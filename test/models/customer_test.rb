require "test_helper"

# You should have at least one positive and one negative test case for each relation, validation, and custom function you add to your models.

describe Customer do
  let(:customer) { customers(:customerone) }
  let(:customertwo) { customers(:customertwo) }

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

  describe "Custom Methods" do
    describe "overdue_items?" do
      it "returns true if customer has overdue items" do
         expect(customertwo.overdue_items?).must_equal true
      end

      it "returns false if customer has no overdue items" do
        expect(customer.overdue_items?).must_equal false
      end
    end
  end
end
