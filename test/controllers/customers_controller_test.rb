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
      fields = %w(id movies_checked_out_count name phone postal_code registered_at)

      get customers_path, as: :json

      body = JSON.parse(response.body)

      body.each do |customer|
        expect(customer.keys.sort).must_equal fields
        expect(customer.keys.length).must_equal fields.length
      end
    end
  end
end
