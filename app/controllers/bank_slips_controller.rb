require 'date'

class BankSlipsController < ApplicationController
  before_action :get_params_id, only: [:cancel, :edit]

  def index
    begin
      @bank_slips = BoletoSimples::BankBillet.all(page: 1, per_page: 50).map do |bank_billet|
        BankSlip.new(
          id: bank_billet.id,
          amount: format('%.2f', bank_billet.amount),
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

  def new
    @bank_slip = BankSlip.new
  end

  def create
    @bank_billet = BoletoSimples::BankBillet.create(
      amount: params[:amount],
      expire_at: Date.strptime(params[:expire_at], '%d/%m/%Y').strftime('%Y-%m-%d'),
      customer_person_name: params[:customer_person_name],
      customer_cnpj_cpf: params[:customer_cnpj_cpf],
      customer_state: params[:customer_state],
      customer_city_name: params[:customer_city_name],
      customer_zipcode: params[:customer_zipcode],
      customer_address: params[:customer_address],
      customer_neighborhood: params[:customer_neighborhood],
    )

    if @bank_billet.persisted?
      respond_to do |format|
        format.html { redirect_to bank_slips_path, notice: 'Criado com sucesso' }
      end
    else
      error_titles = @bank_billet.response_errors.map { |attribute, messages| messages.map { |message| "#{attribute}: #{message}" } }.flatten
      flash[:error_list] = error_titles
      redirect_to new_bank_slip_path
    end
  end

  def edit
    begin
      bank_billet_data = BoletoSimples::BankBillet.find(@bank_billet_id).data

      @bank_slip = BankSlip.new(
        id: bank_billet_data[:id],
        amount: format('%.2f', bank_billet_data[:amount]),
        status: bank_billet_data[:status],
        expire_at: bank_billet_data[:expire_at],
        customer_person_name: bank_billet_data[:customer_person_name],
        customer_cnpj_cpf: bank_billet_data[:customer_cnpj_cpf],
        customer_state: bank_billet_data[:customer_state],
        customer_city_name: bank_billet_data[:customer_city_name],
        customer_zipcode: bank_billet_data[:customer_zipcode],
        customer_address: bank_billet_data[:customer_address],
        customer_neighborhood: bank_billet_data[:customer_neighborhood],
      )
    rescue StandardError => e
      flash[:error] = "Boleto não encontado: #{e.message}"
      redirect_back fallback_location: root_path
    end
  end

  def update
    puts "Hello world ALOU"
  end

  def cancel
    begin
      @bank_billet = BoletoSimples::BankBillet.cancel(id: @bank_billet_id)

      if @bank_billet.response_errors.empty?
        respond_to do |format|
        format.html { redirect_to bank_slips_path, notice: 'Cancelado com sucesso' }
      end
      else
        error_titles = @bank_billet.response_errors.map { |error| error[:title] }
        flash[:error] = error_titles.join(", ")
        redirect_to bank_slips_path
      end
    rescue StandardError => e
      flash[:error] = "Boleto não encontado: #{e.message}"
      redirect_back fallback_location: root_path
    end
  end

  private
    def get_params_id
      @bank_billet_id = params[:id]
    end
end
