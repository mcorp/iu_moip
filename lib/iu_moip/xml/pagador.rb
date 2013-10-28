module IuMoip
  class XML
    class Pagador
      include IuMoip::XML::CreateNode
      attr_accessor :root
      def initialize(_root)
        @root = _root
      end

      def pagador
        @pagador ||= create_node(root, 'Pagador')
      end

      attr_reader :nome, :email, :id_pagador, :logradouro, :numero, :cidade, :estado, :cep, :telefone_fixo, :complemento, :bairro, :pais

      # TODO: writers with validations?
      def nome=(_nome)
        set_node(pagador, 'Nome', _nome)
      end

      def email=(_email)
        set_node(pagador, 'Email', _email)
      end

      def id_pagador=(_idpagador)
        set_node(pagador, 'IdPagador', _idpagador)
      end

      def endereco_cobranca
        @endereco_cobranca ||= create_node(pagador, 'EnderecoCobranca')
      end

      EndCobr = { 
        logradouro:    'Logradouro',
        numero:        'Numero',
        complemento:   'Complemento',
        bairro:        'Bairro',
        cidade:        'Cidade',
        estado:        'Estado',
        pais:          'Pais',
        cep:           'CEP',
        telefone_fixo: 'TelefoneFixo'
      }

      EndCobr.each do |method, field|
        define_method("#{method=}") do |val|
          set_node(endereco_cobranca, field, val)
        end
      end

      attr_reader *EndCobr.keys
    end
  end
end