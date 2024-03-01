class BankSlipsController < ApplicationController
  def index
    @bank_slips = BoletoSimples::BankBillet.all(page: 1, per_page: 50).map do |bank_billet|
      BankSlip.new(
        id: bank_billet.id,
        amount: bank_billet.amount,
        expire_at: bank_billet.expire_at,
        customer_person_name: bank_billet.customer_person_name,
        customer_cnpj_cpf: bank_billet.customer_cnpj_cpf,
        customer_state: bank_billet.customer_state,
        customer_city_name: bank_billet.customer_city_name,
        customer_zipcode: bank_billet.customer_zipcode,
        customer_address: bank_billet.customer_address,
        customer_neighborhood: bank_billet.customer_neighborhood
      )
    end
  end

  def create

  end

  def update

  end

  def cancel
    respond_to do |format|
        format.html { redirect_to bank_slips_path, notice: 'Cancelado' }
    end
  end
end
