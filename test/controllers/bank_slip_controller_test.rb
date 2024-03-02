require 'test_helper'
require 'minitest/mock'
require 'minitest/autorun'

class BankSlipsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    bank_slips = [
      OpenStruct.new(id: 1, amount: '32.90', status: 'pending', expire_at: '2029-12-08', customer_person_name: 'John Doe', customer_cnpj_cpf: '45123046810'),
      OpenStruct.new(id: 2, amount: '45.00', status: 'paid', expire_at: '2029-12-10', customer_person_name: 'Jane Doe', customer_cnpj_cpf: '12345678901')
    ]

    BoletoSimples::BankBillet.stub(:all, bank_slips) do
      get bank_slips_url

      assert_response :success
      assert_not_nil assigns(:bank_slips)

      assert_equal bank_slips.map(&:id), assigns(:bank_slips).map(&:id)
      assert_equal bank_slips.map(&:amount), assigns(:bank_slips).map(&:amount)
      assert_equal bank_slips.map(&:status), assigns(:bank_slips).map(&:status)
      assert_equal bank_slips.map(&:expire_at), assigns(:bank_slips).map(&:expire_at)
      assert_equal bank_slips.map(&:customer_person_name), assigns(:bank_slips).map(&:customer_person_name)
      assert_equal bank_slips.map(&:customer_cnpj_cpf), assigns(:bank_slips).map(&:customer_cnpj_cpf)
    end
  end

  test 'should handle index failure' do
    BoletoSimples::BankBillet.stub(:all, -> { raise StandardError, 'Erro ao recuperar boletos' }) do
      get bank_slips_url

      assert_equal 'Erro ao carregar boletos: wrong number of arguments (given 1, expected 0)', flash[:error]
    end
  end

  test 'should get new' do
    get new_bank_slip_url
    assert_response :success
  end

  test 'should handle create success' do
    BoletoSimples::BankBillet.stub(:create, -> (params) {
      OpenStruct.new(persisted?: true, response_errors: [])
    }) do
      params = {
        amount: '32,90',
        expire_at: '08/12/2029',
        customer_person_name: 'John Doe',
        customer_cnpj_cpf: '45123046810',
        customer_state: 'SC',
        customer_city_name: 'San Francisco',
        customer_zipcode: '88058581',
        customer_address: "123 Main St",
        customer_neighborhood: "Downtown"
      }

      post bank_slips_url, params: params
      assert_redirected_to bank_slips_path
      assert_equal 'Criado com sucesso', flash[:notice]
    end
  end

  test 'should handle create failure' do
    BoletoSimples::BankBillet.stub(:create, -> (params) {
      OpenStruct.new(persisted?: false, response_errors: { amount: ['deve ser maior ou igual a 1'] })
    }) do
      params = {
        amount: 'teste',
        expire_at: '08/12/2029',
        customer_person_name: 'John Doe',
        customer_cnpj_cpf: '45123046810',
        customer_state: 'SC',
        customer_city_name: 'San Francisco',
        customer_zipcode: '88058581',
        customer_address: "123 Main St",
        customer_neighborhood: "Downtown"
      }

      post bank_slips_url, params: params
      assert_redirected_to new_bank_slip_path
      assert_equal ["amount: deve ser maior ou igual a 1"], flash[:error_list]
    end
  end

  test 'should handle cancel success' do
    BoletoSimples::BankBillet.stub(:cancel, -> (params) {
      OpenStruct.new(response_errors: [])
    }) do
      patch bank_slips_cancel_url(id: 1)

      assert_redirected_to bank_slips_path
      assert_equal 'Cancelado com sucesso', flash[:notice]
    end
  end

  test 'should handle cancel failure' do
    BoletoSimples::BankBillet.stub(:cancel, -> (params) {
      OpenStruct.new(response_errors: [{ title: 'Boleto não encontrado' }])
    }) do
      patch bank_slips_cancel_url(id: 1)

      assert_redirected_to bank_slips_path
      assert_equal 'Boleto não encontrado', flash[:error]
    end
  end

  test 'should handle update success' do
    id = 1
    expire_at = '31/03/2024'
    amount = '100.00'

    bank_billet_mock = Minitest::Mock.new
    bank_billet_mock.expect(:save, true)
    bank_billet_mock.expect(:expire_at=, nil, [Date.strptime(expire_at, '%d/%m/%Y').strftime('%Y-%m-%d')])
    bank_billet_mock.expect(:amount=, nil, [amount])

    BoletoSimples::BankBillet.stub(:find, bank_billet_mock) do
      BoletoSimples::BankBillet.stub(:new, bank_billet_mock) do
        put bank_slip_url(id: id), params: { expire_at: expire_at, amount: amount }

        assert_redirected_to bank_slips_path
        assert_equal 'Atualizado com sucesso', flash[:notice]
      end
    end
  end
  test 'should handle update failure' do
    id = 1
    expire_at = '31/03/2024'
    amount = 100.00

    BoletoSimples::BankBillet.stub(:find, -> (id) {
      OpenStruct.new(id: id, response_errors: { amount: ['Amount must be greater than 0'] })
    }) do
      patch bank_slip_url(id: id, expire_at: expire_at, amount: amount)

      assert_redirected_to new_bank_slip_path
      assert_equal 'amount: Amount must be greater than 0', flash[:error_list].join(', ')
    end
  end
end
