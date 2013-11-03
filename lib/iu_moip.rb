require "iu_moip/version"
require 'iu_moip/xml'
require 'httparty'
require 'ostruct'

require 'nokogiri'

module IuMoip
  attr_writer :last_response_raw
  autoload :XML, 'iu_moip/xml'

  class << self
    def env(_env = nil)
      @env = _env if _env
      @env ||= (ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development')
    end

    def base_uri(_base = nil)
      @base_uri = _base if _base
      @base_uri ||= (env == 'production' ? 'https://www.moip.com.br' : 'https://desenvolvedor.moip.com.br/sandbox')
    end
  end

  class Client
    include HTTParty

    base_uri IuMoip.base_uri

    attr_accessor :auth

    def initialize(token, key)
      @auth = { username: token, password: key }
    end

    def body
      <<-BODY.gsub(/^.{1,8}/, '')
        <EnviarInstrucao>
            <InstrucaoUnica TipoValidacao="Transparente">
                <Razao>Razão / Motivo do pagamento</Razao>
                <Valores>
                    <Valor moeda='BRL'>100.00</Valor>
                </Valores>
                <IdProprio>ABC1234</IdProprio>
                <Parcelamentos>
                    <Parcelamento>
                        <MinimoParcelas>2</MinimoParcelas>
                        <MaximoParcelas>3</MaximoParcelas>
                        <Juros>0</Juros>
                    </Parcelamento>
                    <Parcelamento>
                        <MinimoParcelas>4</MinimoParcelas>
                        <MaximoParcelas>6</MaximoParcelas>
                        <Repassar>true</Repassar>
                    </Parcelamento>
                    <Parcelamento>
                        <MinimoParcelas>7</MinimoParcelas>
                        <MaximoParcelas>12</MaximoParcelas>
                        <Juros>2.99</Juros>
                    </Parcelamento>
                </Parcelamentos>
                <Pagador>
                   <Nome>Nome Sobrenome</Nome>
                   <Email>email@cliente.com.br</Email>
                   <IdPagador>id_usuario</IdPagador>
                   <EnderecoCobranca>
                       <Logradouro>Rua do Zézinho Coração</Logradouro>
                       <Numero>45</Numero>
                       <Complemento>z</Complemento>
                       <Bairro>Palhaço Jão</Bairro>
                       <Cidade>São Paulo</Cidade>
                       <Estado>SP</Estado>
                       <Pais>BRA</Pais>
                       <CEP>01230-000</CEP>
                       <TelefoneFixo>(11)8888-8888</TelefoneFixo>
                   </EnderecoCobranca>
               </Pagador>
            </InstrucaoUnica>
        </EnviarInstrucao>
      BODY
    end

    def checkout(opts = {})
      send_operation(:checkout, { body: body })
    end

    def query(token)
      send_operation(:query, token: token)
    end

    def pay()
    end

    def installment
    end

    attr_reader :last_response

    def last_response=(req)
      @last_response_raw = req.dup
      if req['EnviarInstrucaoUnicaResponse']
        @last_response = hash_to_openstruct(req['EnviarInstrucaoUnicaResponse']['Resposta'])
      elsif req['XMLFault']
        @last_response = hash_to_openstruct(req['XMLFault'])
        @last_response.status = 'XMLFault'
        @last_response
      end
    end

    def hash_to_openstruct(hash)
      OpenStruct.new(Hash[hash.map { |k, v| [k.downcase, v] }])
    end

    # op == :checkout | :query
    def send_operation(op, options = {})
      op = operations.send(op)
      return nil unless op
      path = merge_vars(op.path, options)
      self.last_response = send(op.verb, path, options)
    end

    def merge_vars(str, vars)
      return str unless str.index('#{')
      ret = str.dup
      str.scan(/(#\{([^\}]+)\})/) do |sub,var|
        value = vars[var.to_sym] || vars[var]
        next unless value
        ret.gsub!(sub, value.to_s)
      end
      ret
    end

    def operations
      @operations ||= OpenStruct.new(
        checkout: OpenStruct.new(
          verb: :post,
          path:   '/ws/alpha/EnviarInstrucao/Unica'
        ),
        query: OpenStruct.new(
          verb: :get,
          path:   '/ws/alpha/ConsultarInstrucao/#{token}'
        ),
        pay: OpenStruct.new(
          verb: :get,
          path: '/rest/pagamento?callback=?'
        ),
        installment: OpenStruct.new(
          verb: :get,
          path: '/rest/pagamento/consultarparcelamento?callback=?'
        )
      )
    end

    def default_options
      {:basic_auth => auth}
    end
  
    def post(path, opts = {})
      opts = default_options.merge(opts)
      self.class.post(path, opts)
    end

    def get(path, opts = {})
      opts = default_options.merge(opts)
      self.class.get(path, opts)
    end
 
  end
end