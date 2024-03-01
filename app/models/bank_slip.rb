class BankSlip
  attr_accessor :id, :amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :customer_state, :customer_city_name, :customer_zipcode, :customer_address, :customer_neighborhood

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
