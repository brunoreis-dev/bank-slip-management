# test/models/bank_slip_test.rb

require 'test_helper'

class BankSlipTest < ActiveSupport::TestCase
  test "new bank slip should be a new record" do
    bank_slip = BankSlip.new
    assert bank_slip.new_record?
  end

  test "bank slip attributes should be set correctly" do
    attributes = {
      id: 1,
      amount: 100.0,
      expire_at: Date.today + 7.days,
      status: "pending",
      customer_person_name: "John Doe",
      customer_cnpj_cpf: "123.456.789-01",
      customer_state: "CA",
      customer_city_name: "Los Angeles",
      customer_zipcode: "90001",
      customer_address: "123 Main St",
      customer_neighborhood: "Downtown"
    }

    bank_slip = BankSlip.new(attributes)

    assert_equal 1, bank_slip.id
    assert_equal 100.0, bank_slip.amount
    assert_equal Date.today + 7.days, bank_slip.expire_at
    assert_equal "pending", bank_slip.status
    assert_equal "John Doe", bank_slip.customer_person_name
    assert_equal "123.456.789-01", bank_slip.customer_cnpj_cpf
    assert_equal "CA", bank_slip.customer_state
    assert_equal "Los Angeles", bank_slip.customer_city_name
    assert_equal "90001", bank_slip.customer_zipcode
    assert_equal "123 Main St", bank_slip.customer_address
    assert_equal "Downtown", bank_slip.customer_neighborhood
  end
end
