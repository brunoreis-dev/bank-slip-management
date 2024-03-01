class BankSlipsController < ApplicationController
  before_action :get_params_id, only: [:cancel, :edit]

  def index
    begin
      @bank_slips = BoletoSimples::BankBillet.all(page: 1, per_page: 50).map do |bank_billet|
        BankSlip.new(
          id: bank_billet.id,
          amount: bank_billet.amount,
          status: bank_billet.status,
          expire_at: bank_billet.expire_at,
          customer_person_name: bank_billet.customer_person_name,
          customer_cnpj_cpf: bank_billet.customer_cnpj_cpf
        )
      end
    rescue StandardError => e
      flash[:error] = "Erro ao carregar boletos: #{e.message}"
      @bank_slips = []
    end
  end

  def create

  end

  def update

  end

  def cancel
    @bank_billet = BoletoSimples::BankBillet.cancel(id: @bank_billet_id)

    if @bank_billet.response_errors.nil?
      respond_to do |format|
        format.html { redirect_to bank_slips_path, notice: 'Cancelado com sucesso' }
      end
    else
      error_titles = @bank_billet.response_errors.map { |error| error[:title] }
      flash[:error] = error_titles.join(", ")
      redirect_to bank_slips_path
    end
  end

  private
    def get_params_id
      @bank_billet_id = params[:id]
    end
end
