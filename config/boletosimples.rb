require 'boletosimples'
# require 'dalli'

  # BoletoSimples.configure do |c|
  #
  # end

BoletoSimples.configure do |c|
  c.environment = ENV['BOLETOSIMPLES_ENV'].to_sym # defaut :sandbox
  # production - https://app.kobana.com.br/conta/api/tokens
  # sandbox - https://app-sandbox.kobana.com.br/conta/api/tokens
  c.api_token = ENV['BOLETOSIMPLES_API_TOKEN']
  c.user_agent = 'b.macedoreis@icloud.com' #Colocar um e-mail válido para contatos técnicos relacionado ao uso da API.
  c.debug = ENV['BOLETOSIMPLES_DEBUG']
  # c.custom_headers = { 'X-CUSTOM' => 'CONTENT' }
  c.cache = ActiveSupport::Cache.lookup_store(:mem_cache_store, ['localhost:11211'],
                                              namespace: 'boletosimples_client',
                                              compress: true)
end
