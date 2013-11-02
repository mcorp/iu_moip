module IuMoip
  class XML
    class Pagador < IuMoip::XML::Base
      autoload :EnderecoCobranca, 'iu_moip/xml/endereco_cobranca'
      implement_set_nodes :nome, :login_moip, :id_pagador, :email, :telefone_celular, :apelido, :identidade

      def endereco_cobranca
        @endereco_cobranca ||= IuMoip::XML::Pagador::EnderecoCobranca.new(doc, base_element)
      end
    end
  end
end