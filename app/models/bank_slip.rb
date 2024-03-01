class BankSlip
  attr_accessor :id, :amount, :expire_at, :status, :customer_person_name, :customer_cnpj_cpf, :customer_state, :customer_city_name, :customer_zipcode, :customer_address, :customer_neighborhood

  def initialize(attributes = {})
    @id = nil
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def new_record?
    @id.nil?
  end
end
